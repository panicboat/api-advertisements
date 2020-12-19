require 'test_helper'

module Campaigns
  class UpdateTest < ActionDispatch::IntegrationTest
    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
      advertiser = ::Advertisers::Operation::Create.call(params: { name: 'advertiser', url: 'http://advertiser.panicboat.net' }, current_user: @current_user)
      @product = ::Products::Operation::Create.call(params: { advertiser_id: advertiser[:model].id, name: 'product', url: 'http://product.panicboat.net' }, current_user: @current_user)
    end

    def default_params
      { product_id: @product[:model].id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { product_id: @product[:model].id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    test 'Permission Deny : No Session' do
      result = Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: result[:model].id, platform: 'ios', store_url: 'http://update.panicboat.net' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      result = Operation::Update.call(params: { id: ctx[:model].id, store_url: 'http://update.panicboat.net' }, current_user: @current_user)
      assert_equal result[:model].store_url, 'http://update.panicboat.net'
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal JSON.parse(e.message), ['Parameters is invalid']
    end
  end
end
