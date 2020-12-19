require 'test_helper'

module Campaigns
  class CreateTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      result = Operation::Create.call(params: default_params, current_user: @current_user)
      assert_equal result[:model].platform, 'ios'
      assert_equal result[:model].store_url, 'http://spec.panicboat.net'
    end

    test 'Create Duplicate StoreUrl' do
      Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params, current_user: @current_user)
      end
      assert_equal ['Store Url has already been taken'], JSON.parse(e.message)
    end
  end
end
