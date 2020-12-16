module Health::Operation
  class Index < Abstract::Operation
    step Model(OpenStruct, :new)
    step Contract::Build(constant: Health::Contract::Index)
    step Contract::Validate()
    step Contract::Persist(method: :sync)
    fail :invalid_params!
    step :model

    def model(ctx, params:, **)
      ctx[:model] = OpenStruct.new({ status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok] })
    end
  end
end
