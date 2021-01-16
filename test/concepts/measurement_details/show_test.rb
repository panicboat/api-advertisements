require 'test_helper'

module MeasurementDetails
  class ShowTest < ActionDispatch::IntegrationTest
    fixtures :measurement_details

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
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

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: measurement_details(:detail).id }, current_user: @current_user)
      assert_equal measurement_details(:detail).end_at, ctx[:model].end_at
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
