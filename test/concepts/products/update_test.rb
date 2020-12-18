require 'test_helper'

module Products
  class UpdateTest < ActionDispatch::IntegrationTest
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

    test 'Permission Deny : No Session' do
      result = Operation::Create.call(params: default_params, current_user: @current_user)
      e = assert_raises InvalidPermissions do
        Operation::Update.call(params: { id: result[:model].id, name: 'This is name.' })
      end
      assert_equal ['Permissions is invalid'], JSON.parse(e.message)
    end

    test 'Update Data' do
      ctx = Operation::Create.call(params: default_params, current_user: @current_user)
      result = Operation::Update.call(params: { id: ctx[:model].id, name: 'This is name.' }, current_user: @current_user)
      assert_equal result[:model].name, 'This is name.'
    end

    test 'Update No Data' do
      e = assert_raises InvalidParameters do
        Operation::Update.call(params: { id: -1 })
      end
      assert_equal JSON.parse(e.message), ['Parameters is invalid']
    end
  end
end
