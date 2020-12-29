require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  fixtures :products

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
    get '/products', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/products/#{products(:simple).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    post '/products', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    patch "/products/#{products(:simple).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/products/#{products(:simple).id}", headers: @headers
    assert_response :success
  end
end
