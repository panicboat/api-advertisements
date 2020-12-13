module Advertisers::Operation
  class Destroy < Abstract::Operation
    step Model(::Advertiser, :find_by)
    step Contract::Build(constant: Advertisers::Contract::Destroy)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :filter!
    step :model!

    def model!(ctx, model:, **)
      model.destroy
    end
  end
end
