require 'test_helper'

module Products
  class DestroyTest < ActionDispatch::IntegrationTest
    fixtures :advertisers, :products

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
    end

    def default_params
      { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { advertiser_id: products(:simple).advertiser_id, name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: products(:simple).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal ::Product.where({ id: products(:simple).id }), []
    end

    test 'Destory Data Related Advertiser' do
      id = products(:simple).id
      ::Advertiser.find(products(:simple).advertiser_id).destroy
      assert_equal ::Product.where({ id: id }), []
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
