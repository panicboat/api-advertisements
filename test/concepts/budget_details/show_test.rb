require 'test_helper'

module BudgetDetails
  class ShowTest < ActionDispatch::IntegrationTest
    fixtures :budget_details, :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
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

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: budget_details(:detail).id }, current_user: @current_user)
      assert_equal ctx[:model].amount, budget_details(:detail).amount
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end