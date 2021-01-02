module Achievements::Operation
  class Show < Abstract::Operation
    step Model(::Achievement, :find_by)
    step Contract::Build(constant: Achievements::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
