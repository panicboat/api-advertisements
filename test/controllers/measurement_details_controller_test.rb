require 'test_helper'

class MeasurementDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :measurement_details

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
    get "/measurements/#{measurement_details(:detail).measurement_id}/details", headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/measurements/#{measurement_details(:detail).measurement_id}/details/#{measurement_details(:detail).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { measurement_id: measurement_details(:detail).measurement_id, url: 'https://measurement.panicboat.net/image.png' }
    post "/measurements/#{measurement_details(:detail).measurement_id}/details", headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { measurement_id: measurement_details(:detail).measurement_id, url: 'https://measurement.panicboat.net/image.png' }
    patch "/measurements/#{measurement_details(:detail).measurement_id}/details/#{measurement_details(:detail).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/measurements/#{measurement_details(:detail).measurement_id}/details/#{measurement_details(:detail).id}", headers: @headers
    assert_response :success
  end
end
