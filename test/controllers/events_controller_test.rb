require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  fixtures :events

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
    get "/campaigns/#{events(:install).campaign_id}/events", headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { campaign_id: events(:install).campaign_id, name: 'Spec' }
    post "/campaigns/#{events(:install).campaign_id}/events", headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { campaign_id: events(:install).campaign_id, name: 'Spec' }
    patch "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/campaigns/#{events(:install).campaign_id}/events/#{events(:install).id}", headers: @headers
    assert_response :success
  end
end
