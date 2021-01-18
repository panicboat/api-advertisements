require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  fixtures :events

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
      get "/campaigns/#{events(:install).campaign_id}/events", headers: @headers
    end
    assert_response :success
  end

  test 'Show' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      get "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { campaign_id: events(:install).campaign_id, name: 'Spec' }
      post "/campaigns/#{events(:install).campaign_id}/events", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Update' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { campaign_id: events(:install).campaign_id, name: 'Spec' }
      patch "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers
    end
    assert_response :success
  end
end
