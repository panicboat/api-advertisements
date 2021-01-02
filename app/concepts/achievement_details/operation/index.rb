module AchievementDetails::Operation
  class Index < Abstract::Operation
    step Model(::AchievementDetail)
    step Contract::Build(constant: AchievementDetails::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ achievement_id: contract.achievement_id }) if contract.achievement_id.present?
      ctx[:model] = OpenStruct.new({ AchievementDetails: data })
    end
  end
end
