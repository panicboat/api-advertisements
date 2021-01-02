module Measurements::Operation
  class Show < Abstract::Operation
    step Model(::Measurement, :find_by)
    step Contract::Build(constant: Measurements::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
