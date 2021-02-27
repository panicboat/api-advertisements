require 'test_helper'

module CampaignPrincipals
  class IndexTest < ActionDispatch::IntegrationTest
    fixtures :campaign_principals, :campaigns

    setup do
      @current_user = JSON.parse({ name: 'Spec' }.to_json, object_class: OpenStruct)
      WebMock.stub_request(:get, %r{#{ENV['HTTP_IAM_URL']}/permissions/}).to_return(
        body: File.read("#{Rails.root}/test/fixtures/files/platform_iam_get_permission.json"),
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      )
    end

    def default_params
      { principal: campaign_principals(:principal).principal, campaign_id: campaigns(:other).id }
    end

    def expected_attrs
      { principal: campaign_principals(:principal).principal, campaign_id: campaigns(:other).id }
    end

    test 'Index Data' do
      ctx = Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].CampaignPrincipals.present?
      assert_equal ::CampaignPrincipal.all.count, ctx[:model].CampaignPrincipals.length
    end

    test 'Index Data Related Campaign' do
      ctx = Operation::Index.call(params: { campaign_id: campaign_principals(:principal).campaign_id }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].CampaignPrincipals.present?
      ctx[:model].CampaignPrincipals.each do |detail|
        details = ::CampaignPrincipal.where({ campaign_id: campaign_principals(:principal).campaign_id })
        assert_equal true, details.pluck(:campaign_id).include?(detail.campaign_id)
      end
    end

    test 'Index Data Related Principal' do
      ctx = Operation::Index.call(params: { principal: campaign_principals(:principal).principal }, current_user: @current_user, action: 'DUMMY_ACTION_ID')
      assert ctx[:model].CampaignPrincipals.present?
      ctx[:model].CampaignPrincipals.each do |detail|
        details = ::CampaignPrincipal.where({ principal: campaign_principals(:principal).principal })
        assert_equal true, details.pluck(:principal).include?(detail.principal)
      end
    end

    test 'Index No Data' do
      ::CampaignPrincipal.all.each(&:destroy)
      assert_equal [], Operation::Index.call(params: {}, current_user: @current_user, action: 'DUMMY_ACTION_ID')[:model].CampaignPrincipals
    end
  end
end
