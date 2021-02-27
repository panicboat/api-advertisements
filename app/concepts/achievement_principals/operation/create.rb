module AchievementPrincipals::Operation
  class Create < Abstract::Operation
    step Model(::AchievementPrincipal, :new)
    step Contract::Build(constant: AchievementPrincipals::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
