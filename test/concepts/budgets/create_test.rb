require 'test_helper'

module Budgets
  class CreateTest < ActionDispatch::IntegrationTest
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
      { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    def expected_attrs
      { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      ctx1 = Operation::Create.call(params: default_params.merge({ start_at: '2019-07-01 00:00:00', end_at: '2019-08-04 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      ctx2 = Operation::Create.call(params: default_params.merge({ start_at: '2019-09-16 00:00:00', end_at: '2019-09-30 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      [ctx1, ctx2].each do |ctx|
        assert ctx.success?
        assert_equal 100_000, ctx[:model].amount
      end
    end

    test 'Create Duplicate Term' do
      Operation::Create.call(params: default_params, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      e1 = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ start_at: '2019-07-01 00:00:00', end_at: '2019-08-31 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e2 = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ start_at: '2019-08-10 00:00:00', end_at: '2019-09-20 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e3 = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ start_at: '2019-09-15 00:00:00', end_at: '2019-10-10 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e4 = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ start_at: '2019-08-01 00:00:00', end_at: '2019-09-30 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      e5 = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ start_at: '2019-08-15 00:00:00', end_at: '2019-09-05 23:59:59' }), current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      [e1, e2, e3, e4, e5].each do |e|
        assert_equal ['Period has already been taken'], JSON.parse(e.message)
      end
    end
  end
end
