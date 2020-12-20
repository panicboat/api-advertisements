require 'test_helper'

module Products
  class IndexTest < ActionDispatch::IntegrationTest
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

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Products.present?
      assert_equal ctx[:model].Products.length, ::Product.all.count
    end

    test 'Index Data Related Advertiser' do
      ctx = Operation::Index.call(params: { advertiser_id: products(:simple).advertiser_id }, current_user: @current_user)
      assert ctx[:model].Products.present?
      ctx[:model].Products.each do |product|
        products = ::Product.where({ advertiser_id: products(:simple).advertiser_id })
        assert_equal products.pluck(:name).include?(product.name), true
      end
    end

    test 'Index No Data' do
      ::Product.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Products, []
    end
  end
end
