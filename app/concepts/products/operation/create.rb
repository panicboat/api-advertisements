module Products::Operation
  class Create < Abstract::Operation
    step Model(::Product, :new)
    step Contract::Build(constant: Products::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
