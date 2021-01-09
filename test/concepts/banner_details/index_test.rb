require 'test_helper'

module BannerDetails
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :banner_details

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
    end

    def expected_attrs
      { banner_id: banner_details(:detail).banner_id, url: 'https://banner.panicboat.net/image.png' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].BannerDetails.present?
      assert_equal ::BannerDetail.all.count, ctx[:model].BannerDetails.length
    end

    test 'Index Data Related Banner' do
      ctx = Operation::Index.call(params: { banner_id: banner_details(:detail).banner_id }, current_user: @current_user)
      assert ctx[:model].BannerDetails.present?
      ctx[:model].BannerDetails.each do |detail|
        details = ::BannerDetail.where({ banner_id: banner_details(:detail).banner_id })
        assert_equal true, details.pluck(:url).include?(detail.url)
      end
    end

    test 'Index No Data' do
      ::BannerDetail.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user)[:model].BannerDetails
    end
  end
end
