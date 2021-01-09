module BannerDetails::Operation
  class Update < Abstract::Operation
    step Model(::BannerDetail, :find_by)
    step Contract::Build(constant: BannerDetails::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
