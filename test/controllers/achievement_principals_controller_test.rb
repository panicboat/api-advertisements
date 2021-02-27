require 'test_helper'

class AchievementPrincipalsControllerTest < ActionDispatch::IntegrationTest
  fixtures :achievement_principals, :achievements

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
      get "/campaign_principals/#{achievement_principals(:principal).campaign_principal_id}/achievements", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { achievement_id: achievements(:achievement1).id }
      post "/campaign_principals/#{achievement_principals(:principal).campaign_principal_id}/achievements", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/campaign_principals/#{achievement_principals(:principal).campaign_principal_id}/achievements/#{achievement_principals(:principal).id}", headers: @headers
    end
    assert_response :success
  end
end
