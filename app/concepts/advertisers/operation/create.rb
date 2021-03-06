module Advertisers::Operation
  class Create < Abstract::Operation
    step Model(::Advertiser, :new)
    step Contract::Build(constant: Advertisers::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
