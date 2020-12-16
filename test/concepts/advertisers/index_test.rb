require 'test_helper'

module Advertisers
  class IndexTest < ActionDispatch::IntegrationTest
    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, "#{ENV['HTTP_IAM_URL']}/permissions/").to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { "Content-Type": 'application/json' }
      )
    end

    def default_params
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    def expected_attrs
      { name: 'Spec', url: 'http://spec.panicboat.net' }
    end

    test 'Index Data' do
      Operation::Create.call(params: { name: 'Spec1', url: 'http://spec1.panicboat.net' }, current_user: @current_user)
      Operation::Create.call(params: { name: 'Spec2', url: 'http://spec2.panicboat.net' }, current_user: @current_user)
      ctx = Operation::Index.call(params: {}, current_user: @current_user)
      assert_equal ctx[:model].Advertisers.length, 2
      ctx[:model].Advertisers.each do |advertiser|
        assert_equal %w[Spec1 Spec2].include?(advertiser.name), true
      end
    end

    test 'Index No Data' do
      assert_equal Operation::Index.call(params: {}, current_user: @current_user)[:model].Advertisers, []
    end
  end
end
