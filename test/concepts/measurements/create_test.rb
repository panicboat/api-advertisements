require 'test_helper'

module Measurements
  class CreateTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      assert ctx.success?
      assert_equal measurements(:measurement).campaign_id, ctx[:model].campaign_id
      assert_equal 'designated', ctx[:model].classification
    end

    test 'Create Duplicate Classification' do
      Operation::Create.call(params: default_params, current_user: @current_user)
      Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params.merge({ classification: 'default' }), current_user: @current_user)
      end
      assert_equal ['Classification has already been taken'], JSON.parse(e.message)
    end
  end
end
