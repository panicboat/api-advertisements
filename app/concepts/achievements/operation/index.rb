module Achievements::Operation
  class Index < Abstract::Operation
    step Model(::Achievement)
    step Contract::Build(constant: Achievements::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      ctx[:model] = OpenStruct.new({ Achievements: data })
    end
  end
end
