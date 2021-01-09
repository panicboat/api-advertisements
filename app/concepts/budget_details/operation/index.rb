module BudgetDetails::Operation
  class Index < Abstract::Operation
    step Model(::BudgetDetail)
    step Contract::Build(constant: BudgetDetails::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ budget_id: contract.budget_id }) if contract.budget_id.present?
      ctx[:model] = OpenStruct.new({ BudgetDetails: data })
    end
  end
end
