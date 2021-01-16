require 'test_helper'

module MeasurementDetails
  class DestroyTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: measurement_details(:detail).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: measurement_details(:detail).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal [], ::MeasurementDetail.where({ id: measurement_details(:detail).id })
    end

    test 'Destory Data Related Measurement' do
      id = measurement_details(:detail).id
      ::Measurement.find(measurement_details(:detail).measurement_id).destroy
      assert_equal [], ::MeasurementDetail.where({ id: id })
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
