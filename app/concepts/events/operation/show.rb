module Events::Operation
  class Show < Abstract::Operation
    step Model(::Event, :find_by)
    step Contract::Build(constant: Events::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
