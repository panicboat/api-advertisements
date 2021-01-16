require 'test_helper'

module BudgetDetails
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :budget_details, :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { budget_id: budget_details(:detail).budget_id, campaign_id: campaigns(:other).id, amount: 50_000 }
    end

    def expected_attrs
      { budget_id: budget_details(:detail).budget_id, campaign_id: campaigns(:other).id, amount: 50_000 }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].BudgetDetails.present?
      assert_equal ::BudgetDetail.all.count, ctx[:model].BudgetDetails.length
    end

    test 'Index Data Related Budget' do
      ctx = Operation::Index.call(params: { budget_id: budget_details(:detail).budget_id }, current_user: @current_user)
      assert ctx[:model].BudgetDetails.present?
      ctx[:model].BudgetDetails.each do |budget_detail|
        budget_details = ::BudgetDetail.where({ budget_id: budget_details(:detail).budget_id })
        assert_equal true, budget_details.pluck(:amount).include?(budget_detail.amount)
      end
    end

    test 'Index No Data' do
      ::BudgetDetail.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user)[:model].BudgetDetails
    end
  end
end
