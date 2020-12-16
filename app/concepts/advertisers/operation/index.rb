module Advertisers::Operation
  class Index < Abstract::Operation
    step Model(::Advertiser)
    step Contract::Build(constant: Advertisers::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ agency_id: contract.agency_id }) if contract.agency_id.present?
      ctx[:model] = OpenStruct.new({ Advertisers: data })
    end
  end
end
