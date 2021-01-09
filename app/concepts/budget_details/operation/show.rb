module BudgetDetails::Operation
  class Show < Abstract::Operation
    step Model(::BudgetDetail, :find_by)
    step Contract::Build(constant: BudgetDetails::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
