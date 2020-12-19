require 'test_helper'

module Campaigns
  class IndexTest < ActionDispatch::IntegrationTest
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

    test 'Index Data' do
      Operation::Create.call(params: { product_id: @product[:model].id, platform: 'ios', store_url: 'http://ios.panicboat.net' }, current_user: @current_user)
      Operation::Create.call(params: { product_id: @product[:model].id, platform: 'android', store_url: 'http://android.panicboat.net' }, current_user: @current_user)
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert_equal ctx[:model].Campaigns.length, 2
      ctx[:model].Campaigns.each do |campaign|
        assert_equal %w[ios android].include?(campaign.platform), true
      end
    end

    test 'Index No Data' do
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Campaigns, []
    end
  end
end
