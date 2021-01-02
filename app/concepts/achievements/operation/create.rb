module Achievements::Operation
  class Create < Abstract::Operation
    step Model(::Achievement, :new)
    step Contract::Build(constant: Achievements::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
