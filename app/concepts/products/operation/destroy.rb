module Products::Operation
  class Destroy < Abstract::Operation
    step Model(::Product, :find_by)
    step Contract::Build(constant: Products::Contract::Destroy)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :scrape!
    step :model!

    def model!(ctx, model:, **)
      model.destroy
    end
  end
end
