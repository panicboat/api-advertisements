module Products::Operation
  class Update < Abstract::Operation
    step Model(::Product, :find_by)
    step Contract::Build(constant: Products::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step Contract::Persist()
  end
end
