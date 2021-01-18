require 'test_helper'

class AchievementDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :achievement_details

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
      get "/achievements/#{achievement_details(:detail).achievement_id}/details", headers: @headers
    end
    assert_response :success
  end

  test 'Show' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      get "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000.5, payment: 700.3, commission: 300.2 }
      post "/achievements/#{achievement_details(:detail).achievement_id}/details", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Update' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000.5, payment: 700.3, commission: 300.2 }
      patch "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end
end
