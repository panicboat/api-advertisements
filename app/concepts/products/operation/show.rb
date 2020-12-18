module Products::Operation
  class Show < Abstract::Operation
    step Model(::Product, :find_by)
    step Contract::Build(constant: Products::Contract::Show)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist(method: :sync)
  end
end
