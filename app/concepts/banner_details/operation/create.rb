module BannerDetails::Operation
  class Create < Abstract::Operation
    step Model(::BannerDetail, :new)
    step Contract::Build(constant: BannerDetails::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
