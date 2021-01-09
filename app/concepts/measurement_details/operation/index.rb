module MeasurementDetails::Operation
  class Index < Abstract::Operation
    step Model(::MeasurementDetail)
    step Contract::Build(constant: MeasurementDetails::Contract::Index)
    step Contract::Validate()
    fail :invalid_params!
    step :permit!
    step :model

    def model(ctx, **)
      contract = ctx[:"contract.default"]
      data = scrape(ctx).paging(contract.limit, contract.offset).order(contract.order)
      data = data.where({ measurement_id: contract.measurement_id }) if contract.measurement_id.present?
      ctx[:model] = OpenStruct.new({ MeasurementDetails: data })
    end
  end
end
