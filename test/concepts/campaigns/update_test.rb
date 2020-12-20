require 'test_helper'

module Campaigns
  class UpdateTest < ActionDispatch::IntegrationTest
    fixtures :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: campaigns(:ios).id, store_url: 'https://www.google.com' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: campaigns(:ios).id, store_url: 'https://www.google.com' }, current_user: @current_user)
      assert ctx.success?
      assert_equal ctx[:model].store_url, 'https://www.google.com'
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal JSON.parse(e.message), ['Parameters is invalid']
    end
  end
end
