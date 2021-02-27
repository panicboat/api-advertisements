module CampaignPrincipals::Operation
  class Index < Abstract::Operation
    step Model(::CampaignPrincipal)
    step Contract::Build(constant: CampaignPrincipals::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ campaign_id: contract.campaign_id }) if contract.campaign_id.present?
      data = data.where({ principal: contract.principal }) if contract.principal.present?
      ctx[:model] = OpenStruct.new({ CampaignPrincipals: data })
    end
  end
end
