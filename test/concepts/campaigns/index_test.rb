require 'test_helper'

module Campaigns
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :products, :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
    end

    def default_params
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Campaigns.present?
      assert_equal ctx[:model].Campaigns.length, ::Campaign.all.count
    end

    test 'Index Data Related Agency' do
      ctx = Operation::Index.call(params: { product_id: campaigns(:ios).product_id }, current_user: @current_user)
      assert ctx[:model].Campaigns.present?
      ctx[:model].Campaigns.each do |campaign|
        campaigns = ::Campaign.where({ product_id: campaigns(:ios).product_id })
        assert_equal campaigns.pluck(:store_url).include?(campaign.store_url), true
      end
    end

    test 'Index No Data' do
      ::Campaign.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Campaigns, []
    end
  end
end
