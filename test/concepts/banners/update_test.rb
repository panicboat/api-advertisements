require 'test_helper'

module Banners
  class UpdateTest < ActionDispatch::IntegrationTest
    fixtures :banners

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { product_id: banners(:banner).product_id, classification: 'image', label: 'Spec' }
    end

    def expected_attrs
      { product_id: banners(:banner).product_id, classification: 'image', label: 'Spec' }
    end

    test 'Permission Deny : No Session' do
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: banners(:banner).id, label: 'label' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Update.call(params: { id: banners(:banner).id, label: 'label' },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx.success?
      assert_equal 'label', ctx[:model].label
    end
  end
end
