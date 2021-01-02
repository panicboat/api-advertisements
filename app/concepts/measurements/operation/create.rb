module Measurements::Operation
  class Create < Abstract::Operation
    step Model(::Measurement, :new)
    step Contract::Build(constant: Measurements::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
