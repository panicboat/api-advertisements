require 'test_helper'

module BudgetDetails
  class UpdateTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: budget_details(:detail).id, amount: 70_000 })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: budget_details(:detail).id, amount: 70_000 }, current_user: @current_user)
      assert ctx.success?
      assert_equal 70_000, ctx[:model].amount
    end

    test 'Total Amount is Invalid' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: budget_details(:detail).id, amount: 600_001 }, current_user: @current_user)
      end
      assert_equal ['Total amount is invalid'], JSON.parse(e.message)
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
