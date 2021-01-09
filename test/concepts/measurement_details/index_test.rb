require 'test_helper'

module MeasurementDetails
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :measurement_details

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { measurement_id: measurement_details(:detail).measurement_id, url: 'https://measurement.panicboat.net/image.png' }
    end

    def expected_attrs
      { measurement_id: measurement_details(:detail).measurement_id, url: 'https://measurement.panicboat.net/image.png' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].MeasurementDetails.present?
      assert_equal ::MeasurementDetail.all.count, ctx[:model].MeasurementDetails.length
    end

    test 'Index Data Related Measurement' do
      ctx = Operation::Index.call(params: { measurement_id: measurement_details(:detail).measurement_id }, current_user: @current_user)
      assert ctx[:model].MeasurementDetails.present?
      ctx[:model].MeasurementDetails.each do |detail|
        details = ::MeasurementDetail.where({ measurement_id: measurement_details(:detail).measurement_id })
        assert_equal true, details.pluck(:url).include?(detail.url)
      end
    end

    test 'Index No Data' do
      ::MeasurementDetail.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user)[:model].MeasurementDetails
    end
  end
end
