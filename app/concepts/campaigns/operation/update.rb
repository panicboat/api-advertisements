module Campaigns::Operation
  class Update < Abstract::Operation
    step Model(::Campaign, :find_by)
    step Contract::Build(constant: Campaigns::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
