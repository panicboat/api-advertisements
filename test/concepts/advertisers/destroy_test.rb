require 'test_helper'

module Advertisers
  class DestroyTest < ActionDispatch::IntegrationTest
    fixtures :advertisers

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
    end

    def default_params
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Permission Deny' do
      e = assert_raises InvalidPermissions do
        Operation::Destroy.call(params: { id: advertisers(:simple).id })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Destory Data' do
      ctx = Operation::Destroy.call(params: { id: advertisers(:simple).id }, current_user: @current_user)
      assert ctx.success?
      assert_equal ::Advertiser.where({ id: advertisers(:simple).id }), []
    end

    test 'Destory Data Related Agency' do
      id = advertisers(:advertiser_related_agency).id
      ::Agency.find(advertisers(:advertiser_related_agency).agency_id).destroy
      assert_equal ::Advertiser.where({ id: id }), []
    end

    test 'Destroy No Data' do
      e = assert_raises InvalidParameters do
        Operation::Destroy.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
