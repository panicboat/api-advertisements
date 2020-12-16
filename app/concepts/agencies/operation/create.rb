module Agencies::Operation
  class Create < Abstract::Operation
    step Model(::Advertiser, :new)
    step Contract::Build(constant: Agencies::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
