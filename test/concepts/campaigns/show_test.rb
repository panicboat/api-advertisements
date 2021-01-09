require 'test_helper'

module Campaigns
  class ShowTest < ActionDispatch::IntegrationTest
    fixtures :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { product_id: campaigns(:ios).product_id, platform: 'ios', store_url: 'http://spec.panicboat.net' }
    end

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: campaigns(:ios).id }, current_user: @current_user)
      assert_equal campaigns(:ios).store_url, ctx[:model].store_url
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
