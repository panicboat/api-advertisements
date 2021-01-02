module Achievements::Operation
  class Update < Abstract::Operation
    step Model(::Achievement, :find_by)
    step Contract::Build(constant: Achievements::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
