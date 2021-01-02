module Measurements::Operation
  class Update < Abstract::Operation
    step Model(::Measurement, :find_by)
    step Contract::Build(constant: Measurements::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
