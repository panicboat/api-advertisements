module AchievementDetails::Operation
  class Update < Abstract::Operation
    step Model(::AchievementDetail, :find_by)
    step Contract::Build(constant: AchievementDetails::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
