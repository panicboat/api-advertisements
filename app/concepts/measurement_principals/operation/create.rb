module MeasurementPrincipals::Operation
  class Create < Abstract::Operation
    step Model(::MeasurementPrincipal, :new)
    step Contract::Build(constant: MeasurementPrincipals::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
