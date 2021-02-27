require 'test_helper'

module MeasurementPrincipals
  class DestroyTest < ActionDispatch::IntegrationTest
    fixtures :measurement_principals, :measurements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_principal_id: measurement_principals(:principal).campaign_principal_id, measurement_id: measurements(:measurement1).id }
    end

    def expected_attrs
      { campaign_principal_id: measurement_principals(:principal).campaign_principal_id, measurement_id: measurements(:measurement1).id }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: measurement_principals(:principal).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: measurement_principals(:principal).id }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx.success?
      assert_equal [], ::MeasurementPrincipal.where({ id: measurement_principals(:principal).id })
    end

    test 'Destory Data Related Measurement' do
      id = measurement_principals(:principal).id
      ::Measurement.find(measurement_principals(:principal).measurement_id).destroy
      assert_equal [], ::MeasurementPrincipal.where({ id: id })
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
