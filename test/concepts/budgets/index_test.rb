require 'test_helper'

module Budgets
  class IndexTest < ActionDispatch::IntegrationTest
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

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Budgets.present?
      assert_equal ::Budget.all.count, ctx[:model].Budgets.length
    end

    test 'Index Data Related Product' do
      ctx = Operation::Index.call(params: { product_id: budgets(:budget1).product_id }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Budgets.present?
      ctx[:model].Budgets.each do |budget|
        budgets = ::Budget.where({ product_id: budgets(:budget1).product_id })
        assert_equal true, budgets.pluck(:amount).include?(budget.amount)
      end
    end

    test 'Index No Data' do
      ::Budget.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].Budgets
    end
  end
end
