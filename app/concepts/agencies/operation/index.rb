module Agencies::Operation
  class Index < Abstract::Operation
    step Model(::Agency)
    step Contract::Build(constant: Agencies::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      ctx[:model] = OpenStruct.new({ Agencies: data })
    end
  end
end
