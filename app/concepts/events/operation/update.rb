module Events::Operation
  class Update < Abstract::Operation
    step Model(::Event, :find_by)
    step Contract::Build(constant: Events::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
