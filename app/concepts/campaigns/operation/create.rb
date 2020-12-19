module Campaigns::Operation
  class Create < Abstract::Operation
    step Model(::Campaign, :new)
    step Contract::Build(constant: Campaigns::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
