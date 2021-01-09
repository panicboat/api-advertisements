require 'test_helper'

class AchievementsControllerTest < ActionDispatch::IntegrationTest
  fixtures :achievements

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
    get '/achievements', headers: @headers
    assert_response :success
  end

  test 'Show' do
    get "/achievements/#{achievements(:achievement).id}", headers: @headers
    assert_response :success
  end

  test 'Create' do
    params = { event_id: achievements(:achievement).event_id, label: 'label' }
    post '/achievements', headers: @headers, params: params
    assert_response :success
  end

  test 'Update' do
    params = { event_id: achievements(:achievement).event_id, label: 'label' }
    patch "/achievements/#{achievements(:achievement).id}", headers: @headers, params: params
    assert_response :success
  end

  test 'Destroy' do
    delete "/achievements/#{achievements(:achievement).id}", headers: @headers
    assert_response :success
  end
end
