require 'test_helper'

class MeasurementPrincipalsControllerTest < ActionDispatch::IntegrationTest
  fixtures :measurement_principals, :measurements

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
      get "/campaign_principals/#{measurement_principals(:principal).campaign_principal_id}/measurements", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { measurement_id: measurements(:measurement1).id }
      post "/campaign_principals/#{measurement_principals(:principal).campaign_principal_id}/measurements", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/campaign_principals/#{measurement_principals(:principal).campaign_principal_id}/measurements/#{measurement_principals(:principal).id}", headers: @headers
    end
    assert_response :success
  end
end
