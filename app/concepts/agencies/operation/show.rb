module Agencies::Operation
  class Show < Abstract::Operation
    step Model(::Agency, :find_by)
    step Contract::Build(constant: Agencies::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
