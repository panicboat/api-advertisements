require 'test_helper'

class BannerDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :banner_details

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
    get "/banners/#{banner_details(:detail).banner_id}/details", headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
    post "/banners/#{banner_details(:detail).banner_id}/details", headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
    patch "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers
    assert_response :success
  end
end
