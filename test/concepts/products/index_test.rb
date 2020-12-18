require 'test_helper'

module Products
  class IndexTest < ActionDispatch::IntegrationTest
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

    test 'Index Data' do
      Operation::Create.call(params: { advertiser_id: @advertiser[:model].id, name: 'Spec1', url: 'http://spec1.panicboat.net' }, current_user: @current_user)
      Operation::Create.call(params: { advertiser_id: @advertiser[:model].id, name: 'Spec2', url: 'http://spec2.panicboat.net' }, current_user: @current_user)
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert_equal ctx[:model].Products.length, 2
      ctx[:model].Products.each do |advertiser|
        assert_equal %w[Spec1 Spec2].include?(advertiser.name), true
      end
    end

    test 'Index No Data' do
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Products, []
    end
  end
end
