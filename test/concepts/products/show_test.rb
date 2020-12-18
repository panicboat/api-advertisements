require 'test_helper'

module Products
  class ShowTest < ActionDispatch::IntegrationTest
    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
      @advertiser = ::Advertisers::Operation::Create.call(params: { name: 'advertiser', url: 'http://advertiser.panicboat.net' }, current_user: @current_user)
    end

    def default_params
      { advertiser_id: @advertiser[:model].id, name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { advertiser_id: @advertiser[:model].id, name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Show Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      result = Operation::Show.call(params: { id: ctx[:model].id }, current_user: @current_user)
      assert_equal result[:model].name, 'Spec'
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
