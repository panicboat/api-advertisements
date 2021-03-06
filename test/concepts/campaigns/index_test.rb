require 'test_helper'

module Campaigns
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
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

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Campaigns.present?
      assert_equal ::Campaign.all.count, ctx[:model].Campaigns.length
    end

    test 'Index Data Related Product' do
      ctx = Operation::Index.call(params: { product_id: campaigns(:ios).product_id }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Campaigns.present?
      ctx[:model].Campaigns.each do |campaign|
        campaigns = ::Campaign.where({ product_id: campaigns(:ios).product_id })
        assert_equal true, campaigns.pluck(:store_url).include?(campaign.store_url)
      end
    end

    test 'Index No Data' do
      ::Campaign.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].Campaigns
    end
  end
end
