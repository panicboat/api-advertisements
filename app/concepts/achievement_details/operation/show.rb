module AchievementDetails::Operation
  class Show < Abstract::Operation
    step Model(::AchievementDetail, :find_by)
    step Contract::Build(constant: AchievementDetails::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
