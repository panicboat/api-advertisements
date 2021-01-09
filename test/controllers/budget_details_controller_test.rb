require 'test_helper'

class BudgetDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :budget_details, :campaigns

  setup do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/tokens").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_list_token.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/users").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_user.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    @headers = { "#{::RequestHeader::USER_CLAIMS}": 'dummy' }
  end

  test 'Index' do
    get "/budgets/#{budget_details(:detail).budget_id}/details", headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { budget_id: budget_details(:detail).budget_id, campaign_id: campaigns(:other).id, amount: 100_000 }
    post "/budgets/#{budget_details(:detail).budget_id}/details", headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { budget_id: budget_details(:detail).budget_id, campaign_id: budget_details(:detail).campaign_id, amount: 50_000 }
    patch "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers
    assert_response :success
  end
end
