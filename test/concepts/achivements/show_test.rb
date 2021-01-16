require 'test_helper'

module Achievements
  class ShowTest < ActionDispatch::IntegrationTest
    fixtures :achievements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { event_id: achievements(:achievement).event_id, label: 'Spec', default: 'false' }
    end

    def expected_attrs
      { event_id: achievements(:achievement).event_id, label: 'Spec', default: 'false' }
    end

    test 'Show Data' do
      ctx = Operation::Show.call(params: { id: achievements(:achievement).id }, current_user: @current_user)
      assert_equal achievements(:achievement).label, ctx[:model].label
    end

    test 'Show No Data' do
      e = assert_raises InvalidParameters do
        Operation::Show.call(params: { id: -1 }, current_user: @current_user)
      end
      assert_equal ['Parameters is invalid'], JSON.parse(e.message)
    end
  end
end
