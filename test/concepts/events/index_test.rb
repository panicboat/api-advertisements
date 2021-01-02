require 'test_helper'

module Events
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :events

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/00000000-0000-0000-0000-000000000000").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_id: events(:install).campaign_id, name: 'spec' }
    end

    def expected_attrs
      { campaign_id: events(:install).campaign_id, name: 'spec' }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert ctx[:model].Events.present?
      assert_equal ctx[:model].Events.length, ::Event.all.count
    end

    test 'Index Data Related Campaign' do
      ctx = Operation::Index.call(params: { campaign_id: events(:install).campaign_id }, current_user: @current_user)
      assert ctx[:model].Events.present?
      ctx[:model].Events.each do |event|
        events = ::Event.where({ campaign_id: events(:install).campaign_id })
        assert_equal events.pluck(:name).include?(event.name), true
      end
    end

    test 'Index No Data' do
      ::Event.all.each(&:destroy)
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Events, []
    end
  end
end