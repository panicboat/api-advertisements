require 'test_helper'

module Events
  class UpdateTest < ActionDispatch::IntegrationTest
    fixtures :events

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
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

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: events(:install).id, name: 'spec name' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: events(:install).id, name: 'spec name' }, current_user: @current_user)
      assert ctx.success?
      assert_equal 'spec name', ctx[:model].name
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
