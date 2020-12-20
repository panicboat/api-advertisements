module Agencies::Operation
  class Create < Abstract::Operation
    step Model(::Agency, :new)
    step Contract::Build(constant: Agencies::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
