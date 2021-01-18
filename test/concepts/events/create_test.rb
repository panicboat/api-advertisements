require 'test_helper'

module Events
  class CreateTest < ActionDispatch::IntegrationTest
    fixtures :events

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_id: events(:install).campaign_id, name: 'spec' }
    end

    def expected_attrs
      { campaign_id: events(:install).campaign_id, name: 'spec' }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      ctx = Operation::Create.call(params: default_params,current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx.success?
      assert_equal events(:install).campaign_id, ctx[:model].campaign_id
      assert_equal 'spec', ctx[:model].name
    end

    test 'Create Duplicate Name' do
      Operation::Create.call(params: default_params,current_user: @current_user, action: 'DUMMY_ACTION_ID')
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params,current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      assert_equal ['Name has already been taken'], JSON.parse(e.message)
    end
  end
end
