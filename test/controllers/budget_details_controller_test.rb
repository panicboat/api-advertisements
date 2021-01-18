require 'test_helper'

class BudgetDetailsControllerTest < ActionDispatch::IntegrationTest
  fixtures :budget_details, :campaigns

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
      get "/budgets/#{budget_details(:detail).budget_id}/details", headers: @headers
    end
    assert_response :success
  end

  test 'Show' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      get "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end

  test 'Create' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { budget_id: budget_details(:detail).budget_id, campaign_id: campaigns(:other).id, amount: 100_000 }
      post "/budgets/#{budget_details(:detail).budget_id}/details", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Update' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      params = { budget_id: budget_details(:detail).budget_id, campaign_id: budget_details(:detail).campaign_id, amount: 50_000 }
      patch "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers, params: params
    end
    assert_response :success
  end

  test 'Destroy' do
    ::Panicboat::AbstractController.stub_any_instance(:_options, @options) do
      delete "/budgets/#{budget_details(:detail).budget_id}/details/#{budget_details(:detail).id}", headers: @headers
    end
    assert_response :success
  end
end
