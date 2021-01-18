require 'test_helper'

module Advertisers
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :advertisers

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Advertisers.present?
      assert_equal ::Advertiser.all.count, ctx[:model].Advertisers.length
    end

    test 'Index Data Related Agency' do
      ctx = Operation::Index.call(params: { agency_id: advertisers(:advertiser_related_agency).agency_id },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Advertisers.present?
      ctx[:model].Advertisers.each do |advertiser|
        advertisers = ::Advertiser.where({ agency_id: advertisers(:advertiser_related_agency).agency_id })
        assert_equal true, advertisers.pluck(:name).include?(advertiser.name)
      end
    end

    test 'Index No Data' do
      ::Advertiser.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].Advertisers
    end
  end
end
