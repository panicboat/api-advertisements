require 'test_helper'

module Achievements
  class UpdateTest < ActionDispatch::IntegrationTest
    fixtures :achievements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { event_id: achievements(:achievement).event_id, label: 'Spec', default: 'false' }
    end

    def expected_attrs
      { event_id: achievements(:achievement).event_id, label: 'Spec', default: 'false' }
    end

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: achievements(:achievement).id, label: 'label', default: 'false' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: achievements(:achievement).id, label: 'label', default: 'false' }, current_user: @current_user)
      assert ctx.success?
      assert_equal 'label', ctx[:model].label
    end

    test 'Update Duplicate Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: achievements(:achievement1).id, label: 'label', default: 'true' }, current_user: @current_user)
      end
      assert_equal ['Event default has already been taken'], JSON.parse(e.message)
    end
  end
end
