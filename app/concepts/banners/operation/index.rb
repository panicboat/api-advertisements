module Banners::Operation
  class Index < Abstract::Operation
    step Model(::Banner)
    step Contract::Build(constant: Banners::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ product_id: contract.product_id }) if contract.product_id.present?
      ctx[:model] = OpenStruct.new({ Banners: data })
    end
  end
end
