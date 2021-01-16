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
    WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/services/#{ENV['PNB_SERVICE_ID']}/actions}).to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_list_action.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
    @headers = { "#{::RequestHeader::USER_CLAIMS}": 'dummy' }
  end

  test 'Index' do
    get '/campaigns', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/campaigns/#{campaigns(:ios).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { product_id: campaigns(:ios).product_id, name: 'Spec', store_url: 'http://spec.panicboat.net', platform: 'android' }
    post '/campaigns', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { product_id: campaigns(:ios).product_id, name: 'Spec', store_url: 'http://spec.panicboat.net', platform: 'android' }
    patch "/campaigns/#{campaigns(:ios).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/campaigns/#{campaigns(:ios).id}", headers: @headers
    assert_response :success
  end
end
