require 'test_helper'

module Advertisers
  class CreateTest < ActionDispatch::IntegrationTest
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
        Operation::Create.call(params: default_params)
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Create Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      assert ctx.success?
      assert_equal ctx[:model].name, 'Spec'
    end

    test 'Create Data Related Agency' do
      ctx = Operation::Create.call(params: default_params.merge(agency_id: advertisers(:advertiser_related_agency).agency_id), current_user: @current_user)
      assert ctx.success?
      assert_equal ctx[:model].name, 'Spec'
    end

    test 'Create Duplicate Url' do
      Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidParameters do
        Operation::Create.call(params: default_params, current_user: @current_user)
      end
      assert_equal ['Url has already been taken'], JSON.parse(e.message)
    end
  end
end
