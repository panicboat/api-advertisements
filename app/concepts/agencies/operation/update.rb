module Agencies::Operation
  class Update < Abstract::Operation
    step Model(::Advertiser, :find_by)
    step Contract::Build(constant: Agencies::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
