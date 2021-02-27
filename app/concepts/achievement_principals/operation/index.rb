module AchievementPrincipals::Operation
  class Index < Abstract::Operation
    step Model(::AchievementPrincipal)
    step Contract::Build(constant: AchievementPrincipals::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ campaign_principal_id: contract.campaign_principal_id }) if contract.campaign_principal_id.present?
      ctx[:model] = OpenStruct.new({ AchievementPrincipals: data })
    end
  end
end
