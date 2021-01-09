require 'test_helper'

module Achievements
  class DestroyTest < ActionDispatch::IntegrationTest
    fixtures :achievements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { event_id: achievements(:achievement).event_id, label: 'Spec' }
    end

    def expected_attrs
      { event_id: achievements(:achievement).event_id, label: 'Spec' }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: achievements(:achievement).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: achievements(:achievement).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal ::Achievement.where({ id: achievements(:achievement).id }), []
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
