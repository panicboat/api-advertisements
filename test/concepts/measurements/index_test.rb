require 'test_helper'

module Measurements
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :measurements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_id: measurements(:measurement).campaign_id, classification: 'designated' }
    end

    def expected_attrs
      { campaign_id: measurements(:measurement).campaign_id, classification: 'designated' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Measurements.present?
      assert_equal ctx[:model].Measurements.length, ::Measurement.all.count
    end

    test 'Index Data Related Campaign' do
      ctx = Operation::Index.call(params: { campaign_id: measurements(:measurement).campaign_id }, current_user: @current_user)
      assert ctx[:model].Measurements.present?
      ctx[:model].Measurements.each do |measurement|
        measurements = ::Measurement.where({ campaign_id: measurements(:measurement).campaign_id })
        assert_equal measurements.pluck(:label).include?(measurement.label), true
      end
    end

    test 'Index No Data' do
      ::Measurement.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Measurements, []
    end
  end
end
