module CampaignPrincipals::Operation
  class Create < Abstract::Operation
    step Model(::CampaignPrincipal, :new)
    step Contract::Build(constant: CampaignPrincipals::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
