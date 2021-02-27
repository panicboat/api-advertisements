require 'test_helper'

module Budgets
  class UpdateTest < ActionDispatch::IntegrationTest
    fixtures :budgets

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { product_id: budgets(:budget3).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    def expected_attrs
      { product_id: budgets(:budget3).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: budgets(:budget3).id, amount: 200_000 })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: budgets(:budget3).id, amount: 200_000 }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx.success?
      assert_equal 200_000, ctx[:model].amount
    end

    test 'Update Data More Than Once' do
      ctx1 = Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-07-01 00:00:00', end_at: '2019-08-04 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      ctx2 = Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-09-16 00:00:00', end_at: '2019-09-30 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      [ctx1, ctx2].each do |ctx|
        assert ctx.success?
        assert_equal 100_000, ctx[:model].amount
      end
    end

    test 'Update Duplicate Term' do
      e1 = assert_raises InvalidParameters do
        Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-07-01 00:00:00', end_at: '2019-08-31 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e2 = assert_raises InvalidParameters do
        Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-08-10 00:00:00', end_at: '2019-09-20 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e3 = assert_raises InvalidParameters do
        Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-09-15 00:00:00', end_at: '2019-10-10 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e4 = assert_raises InvalidParameters do
        Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-08-01 00:00:00', end_at: '2019-09-30 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e5 = assert_raises InvalidParameters do
        Operation::Update.call(params: default_params.merge({ id: budgets(:budget3).id, start_at: '2019-08-15 00:00:00', end_at: '2019-09-05 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      [e1, e2, e3, e4, e5].each do |e|
        assert_equal ['Period has already been taken'], JSON.parse(e.message)
      end
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
