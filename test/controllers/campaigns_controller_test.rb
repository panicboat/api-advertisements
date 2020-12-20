require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  fixtures :campaigns

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
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:ListCampaign").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get '/campaigns', headers: @headers
    assert_response :success
  end

  test 'Show' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:GetCampaign").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get "/campaigns/#{campaigns(:ios).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:CreateCampaign").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { product_id: campaigns(:ios).product_id, name: 'Spec', store_url: 'http://spec.panicboat.net', platform: 'android' }
    post '/campaigns', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:UpdateCampaign").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { product_id: campaigns(:ios).product_id, name: 'Spec', store_url: 'http://spec.panicboat.net', platform: 'android' }
    patch "/campaigns/#{campaigns(:ios).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:DeleteCampaign").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    delete "/campaigns/#{campaigns(:ios).id}", headers: @headers
    assert_response :success
  end
end
