require 'test_helper'

class BannerDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :banner_details

  def setup
    @options = { action: '00000000-0000-0000-0000-000000000000', current_user: { email: 'spec@panicboat.net' } }
    WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
      body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
  end

  test 'Index' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      get "/banners/#{banner_details(:detail).banner_id}/details", headers: @headers
    end
    assert_response :success
  end

  test 'Show' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      get "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
      post "/banners/#{banner_details(:detail).banner_id}/details", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Update' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
      patch "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/banners/#{banner_details(:detail).banner_id}/details/#{banner_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end
end
