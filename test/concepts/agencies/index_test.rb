require 'test_helper'

module Agencies
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :agencies

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Agencies.present?
      assert_equal ::Agency.all.count, ctx[:model].Agencies.length
    end

    test 'Index No Data' do
      ::Agency.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].Agencies
    end
  end
end
