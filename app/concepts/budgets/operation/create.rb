module Budgets::Operation
  class Create < Abstract::Operation
    step Model(::Budget, :new)
    step Contract::Build(constant: Budgets::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
