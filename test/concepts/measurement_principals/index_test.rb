require 'test_helper'

module MeasurementPrincipals
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :measurement_principals, :measurements

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { campaign_principal_id: measurement_principals(:principal).campaign_principal_id, measurement_id: measurements(:measurement1).id }
    end

    def expected_attrs
      { campaign_principal_id: measurement_principals(:principal).campaign_principal_id, measurement_id: measurements(:measurement1).id }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].MeasurementPrincipals.present?
      assert_equal ::MeasurementPrincipal.all.count, ctx[:model].MeasurementPrincipals.length
    end

    test 'Index Data Related Measurement' do
      ctx = Operation::Index.call(params: { campaign_principal_id: measurement_principals(:principal).campaign_principal_id }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].MeasurementPrincipals.present?
      ctx[:model].MeasurementPrincipals.each do |detail|
        details = ::MeasurementPrincipal.where({ campaign_principal_id: measurement_principals(:principal).campaign_principal_id })
        assert_equal true, details.pluck(:campaign_principal_id).include?(detail.campaign_principal_id)
      end
    end

    test 'Index No Data' do
      ::MeasurementPrincipal.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].MeasurementPrincipals
    end
  end
end
