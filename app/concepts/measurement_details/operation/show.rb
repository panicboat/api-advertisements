module MeasurementDetails::Operation
  class Show < Abstract::Operation
    step Model(::MeasurementDetail, :find_by)
    step Contract::Build(constant: MeasurementDetails::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
