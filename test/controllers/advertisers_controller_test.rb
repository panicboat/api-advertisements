require 'test_helper'

class AdvertisersControllerTest < ActionDispatch::IntegrationTest
  fixtures :advertisers

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
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:ListAdvertiser").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get '/advertisers', headers: @headers
    assert_response :success
  end

  test 'Show' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:GetAdvertiser").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    get "/advertisers/#{advertisers(:simple).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:CreateAdvertiser").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { name: 'Spec', url: 'http://spec.panicboat.net' }
    post '/advertisers', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:UpdateAdvertiser").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    params = { name: 'Spec', url: 'http://spec.panicboat.net' }
    patch "/advertisers/#{advertisers(:simple).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/#{ENV['AWS_ECS_SERVICE_NAME']}:DeleteAdvertiser").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    delete "/advertisers/#{advertisers(:simple).id}", headers: @headers
    assert_response :success
  end
end
