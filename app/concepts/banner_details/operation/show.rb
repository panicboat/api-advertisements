module BannerDetails::Operation
  class Show < Abstract::Operation
    step Model(::BannerDetail, :find_by)
    step Contract::Build(constant: BannerDetails::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
