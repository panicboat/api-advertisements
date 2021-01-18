require 'test_helper'

module Banners
  class IndexTest < ActionDispatch::IntegrationTest
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

    test 'Index Data' do
      ctx = Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Banners.present?
      assert_equal ::Banner.all.count, ctx[:model].Banners.length
    end

    test 'Index Data Related Product' do
      ctx = Operation::Index.call(params: { product_id: banners(:banner).product_id },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].Banners.present?
      ctx[:model].Banners.each do |banner|
        banners = ::Banner.where({ product_id: banners(:banner).product_id })
        assert_equal true, banners.pluck(:label).include?(banner.label)
      end
    end

    test 'Index No Data' do
      ::Banner.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].Banners
    end
  end
end
