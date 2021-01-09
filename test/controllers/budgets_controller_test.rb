require 'test_helper'

class BudgetsControllerTest < ActionDispatch::IntegrationTest
  fixtures :budgets

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
    get '/budgets', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/budgets/#{budgets(:budget1).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 100_000 }
    post '/budgets', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { product_id: budgets(:budget1).product_id, start_at: '2019-08-05 00:00:00', end_at: '2019-09-15 23:59:59', amount: 2_000_000 }
    patch "/budgets/#{budgets(:budget1).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/budgets/#{budgets(:budget1).id}", headers: @headers
    assert_response :success
  end
end
