module Advertisers::Operation
  class Index < Abstract::Operation
    step Model(::Advertiser)
    step Contract::Build(constant: Advertisers::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :model

    def model(ctx, **)
      contract = contract(ctx)
      data = ::Advertiser.paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ agency_id: contract.agency_id }) if contract.agency_id.present?
      ctx[:model] = OpenStruct.new({ Advertisers: data })
    end
  end
end
