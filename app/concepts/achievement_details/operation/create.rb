module AchievementDetails::Operation
  class Create < Abstract::Operation
    step Model(::AchievementDetail, :new)
    step Contract::Build(constant: AchievementDetails::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
