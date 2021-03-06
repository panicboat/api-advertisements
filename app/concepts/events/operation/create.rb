module Events::Operation
  class Create < Abstract::Operation
    step Model(::Event, :new)
    step Contract::Build(constant: Events::Contract::Create)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step Contract::Persist()
  end
end
