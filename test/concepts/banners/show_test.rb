require 'test_helper'

module Banners
  class ShowTest < ActionDispatch::IntegrationTest
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

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: banners(:banner).id },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert_equal banners(:banner).label, ctx[:model].label
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
