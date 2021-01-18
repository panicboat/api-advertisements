require 'test_helper'

module AchievementDetails
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :achievement_details

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000, payment: 700, commission: 300 }
    end

    def expected_attrs
      { achievement_id: achievement_details(:detail).achievement_id, charge: 1_000, payment: 700, commission: 300 }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].AchievementDetails.present?
      assert_equal ::AchievementDetail.all.count, ctx[:model].AchievementDetails.length
    end

    test 'Index Data Related Achievement' do
      ctx = Operation::Index.call(params: { achievement_id: achievement_details(:detail).achievement_id },current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].AchievementDetails.present?
      ctx[:model].AchievementDetails.each do |detail|
        details = ::AchievementDetail.where({ achievement_id: achievement_details(:detail).achievement_id })
        assert_equal true, details.pluck(:charge).include?(detail.charge)
      end
    end

    test 'Index No Data' do
      ::AchievementDetail.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {},current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].AchievementDetails
    end
  end
end
