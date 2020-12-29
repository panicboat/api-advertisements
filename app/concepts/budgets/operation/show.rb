module Budgets::Operation
  class Show < Abstract::Operation
    step Model(::Budget, :find_by)
    step Contract::Build(constant: Budgets::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
