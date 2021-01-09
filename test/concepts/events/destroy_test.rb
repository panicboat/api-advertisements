require 'test_helper'

module Events
  class DestroyTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: events(:install).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: events(:install).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal [], ::Event.where({ id: events(:install).id })
    end

    test 'Destory Data Related Campaign' do
      id = events(:install).id
      ::Campaign.find(events(:install).campaign_id).destroy
      assert_equal [], ::Event.where({ id: id })
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
