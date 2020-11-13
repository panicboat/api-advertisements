module Advertisers::Operation
  class Update < Abstract::Operation
    step Model(::Advertiser, :find_by)
    step Contract::Build(constant: Advertisers::Contract::Update)
    step Contract::Validate()
    fail :invalid_params!
    step Contract::Persist()
  end
end
