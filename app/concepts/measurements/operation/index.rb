module Measurements::Operation
  class Index < Abstract::Operation
    step Model(::Measurement)
    step Contract::Build(constant: Measurements::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ campaign_id: contract.campaign_id }) if contract.campaign_id.present?
      ctx[:model] = OpenStruct.new({ Measurements: data })
    end
  end
end
