module AchievementDetails::Operation
  class Destroy < Abstract::Operation
    step Model(::AchievementDetail, :find_by)
    step Contract::Build(constant: AchievementDetails::Contract::Destroy)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step :model!

    def model!(ctx, model:, **)
      model.destroy
    end
  end
end
