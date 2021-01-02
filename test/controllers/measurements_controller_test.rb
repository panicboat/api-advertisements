require 'test_helper'

class MeasurementsControllerTest < ActionDispatch::IntegrationTest
  fixtures :measurements

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
    get '/measurements', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/measurements/#{measurements(:measurement).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { campaign_id: measurements(:measurement).campaign_id, classification: 'designated' }
    post '/measurements', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { campaign_id: measurements(:measurement).campaign_id, classification: 'designated' }
    patch "/measurements/#{measurements(:measurement).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/measurements/#{measurements(:measurement).id}", headers: @headers
    assert_response :success
  end
end
