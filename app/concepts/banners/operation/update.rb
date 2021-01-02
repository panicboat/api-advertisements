module Banners::Operation
  class Update < Abstract::Operation
    step Model(::Banner, :find_by)
    step Contract::Build(constant: Banners::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
