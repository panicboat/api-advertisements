module Budgets::Operation
  class Update < Abstract::Operation
    step Model(::Budget, :find_by)
    step Contract::Build(constant: Budgets::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
