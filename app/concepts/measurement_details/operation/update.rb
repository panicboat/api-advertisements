module MeasurementDetails::Operation
  class Update < Abstract::Operation
    step Model(::MeasurementDetail, :find_by)
    step Contract::Build(constant: MeasurementDetails::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
