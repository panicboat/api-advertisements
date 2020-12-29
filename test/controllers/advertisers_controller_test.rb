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
    WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    @headers = { "#{::RequestHeader::USER_CLAIMS}": 'dummy' }
  end

  test 'Index' do
    get '/advertisers', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/advertisers/#{advertisers(:simple).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { name: 'Spec', url: 'http://spec.panicboat.net' }
    post '/advertisers', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { name: 'Spec', url: 'http://spec.panicboat.net' }
    patch "/advertisers/#{advertisers(:simple).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/advertisers/#{advertisers(:simple).id}", headers: @headers
    assert_response :success
  end
end
