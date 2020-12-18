module Products::Operation
  class Index < Abstract::Operation
    step Model(::Product)
    step Contract::Build(constant: Products::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ advertiser_id: contract.advertiser_id }) if contract.advertiser_id.present?
      ctx[:model] = OpenStruct.new({ Products: data })
    end
  end
end
