require 'test_helper'

module Achievements
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :achievements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { label: 'Spec' }
    end

    def expected_attrs
      { label: 'Spec' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Achievements.present?
      assert_equal ctx[:model].Achievements.length, ::Achievement.all.count
    end

    test 'Index Data Related Product' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Achievements.present?
      ctx[:model].Achievements.each do |achievement|
        achievements = ::Achievement.where({})
        assert_equal achievements.pluck(:label).include?(achievement.label), true
      end
    end

    test 'Index No Data' do
      ::Achievement.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Achievements, []
    end
  end
end
