module BudgetDetails::Operation
  class Update < Abstract::Operation
    step Model(::BudgetDetail, :find_by)
    step Contract::Build(constant: BudgetDetails::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
