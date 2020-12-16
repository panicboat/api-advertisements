module Advertisers::Operation
  class Show < Abstract::Operation
    step Model(::Advertiser, :find_by)
    step Contract::Build(constant: Advertisers::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
