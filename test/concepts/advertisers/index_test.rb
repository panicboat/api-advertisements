require 'test_helper'

module Advertisers
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :agencies, :advertisers

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
    end

    def default_params
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Advertisers.present?
      assert_equal ctx[:model].Advertisers.length, ::Advertiser.all.count
    end

    test 'Index Data Related Agency' do
      ctx = Operation::Index.call(params: { agency_id: advertisers(:advertiser_related_agency).agency_id }, current_user: @current_user)
      assert ctx[:model].Advertisers.present?
      ctx[:model].Advertisers.each do |advertiser|
        advertisers = ::Advertiser.where({ agency_id: advertisers(:advertiser_related_agency).agency_id })
        assert_equal advertisers.pluck(:name).include?(advertiser.name), true
      end
    end

    test 'Index No Data' do
      ::Advertiser.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Advertisers, []
    end
  end
end
