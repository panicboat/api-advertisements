module Campaigns::Operation
  class Show < Abstract::Operation
    step Model(::Campaign, :find_by)
    step Contract::Build(constant: Campaigns::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
