module Banners::Operation
  class Create < Abstract::Operation
    step Model(::Banner, :new)
    step Contract::Build(constant: Banners::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
