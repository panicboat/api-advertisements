module MeasurementDetails::Operation
  class Create < Abstract::Operation
    step Model(::MeasurementDetail, :new)
    step Contract::Build(constant: MeasurementDetails::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
