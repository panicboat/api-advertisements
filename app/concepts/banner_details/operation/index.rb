module BannerDetails::Operation
  class Index < Abstract::Operation
    step Model(::BannerDetail)
    step Contract::Build(constant: BannerDetails::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ banner_id: contract.banner_id }) if contract.banner_id.present?
      ctx[:model] = OpenStruct.new({ BannerDetails: data })
    end
  end
end
