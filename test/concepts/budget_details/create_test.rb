require 'test_helper'

module BudgetDetails
  class CreateTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      assert ctx.success?
      assert_equal budget_details(:detail).budget_id, ctx[:model].budget_id
      assert_equal campaigns(:other).id, ctx[:model].campaign_id
      assert_equal 50_000, ctx[:model].amount
    end

    test 'Create Duplicate Data' do
      Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params, current_user: @current_user)
      end
      assert_equal ['Campaign has already been taken'], JSON.parse(e.message)
    end

    test 'Total Amount is Invalid' do
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ amount: 100_001 }), current_user: @current_user)
      end
      assert_equal ['Total amount is invalid'], JSON.parse(e.message)
    end
  end
end
