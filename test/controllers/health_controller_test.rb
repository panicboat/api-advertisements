require 'test_helper'

class HealthControllerTest < ActionDispatch::IntegrationTest
  test 'Index' do
    get '/health'
    assert_response :success
  end
end
