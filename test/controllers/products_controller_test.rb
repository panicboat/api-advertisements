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
    @headers = { "#{::RequestHeader::USER_CLAIMS}": 'dummy' }
  end

  test 'Index' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:ListProduct").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get '/products', headers: @headers
    assert_response :success
  end

  test 'Show' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:GetProduct").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get "/products/#{products(:simple).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:CreateProduct").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    post '/products', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:UpdateProduct").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    patch "/products/#{products(:simple).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:DeleteProduct").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    delete "/products/#{products(:simple).id}", headers: @headers
    assert_response :success
  end
end
