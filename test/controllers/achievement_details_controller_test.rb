require 'test_helper'

class AchievementDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :achievement_details

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
    get "/achievements/#{achievement_details(:detail).achievement_id}/details", headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000.5, payment: 700.3, commission: 300.2 }
    post "/achievements/#{achievement_details(:detail).achievement_id}/details", headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000.5, payment: 700.3, commission: 300.2 }
    patch "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/achievements/#{achievement_details(:detail).achievement_id}/details/#{achievement_details(:detail).id}", headers: @headers
    assert_response :success
  end
end
