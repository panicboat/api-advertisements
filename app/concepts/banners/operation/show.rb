module Banners::Operation
  class Show < Abstract::Operation
    step Model(::Banner, :find_by)
    step Contract::Build(constant: Banners::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
