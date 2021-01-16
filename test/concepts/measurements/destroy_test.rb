require 'test_helper'

module Measurements
  class DestroyTest < ActionDispatch::IntegrationTest
    fixtures :measurements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_id: measurements(:measurement).campaign_id, default: 'false' }
    end

    def expected_attrs
      { campaign_id: measurements(:measurement).campaign_id, default: 'false' }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: measurements(:measurement).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: measurements(:measurement).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal [], ::Measurement.where({ id: measurements(:measurement).id })
    end

    test 'Destory Data Related Campaign' do
      id = measurements(:measurement).id
      ::Campaign.find(measurements(:measurement).campaign_id).destroy
      assert_equal [], ::Measurement.where({ id: id })
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
