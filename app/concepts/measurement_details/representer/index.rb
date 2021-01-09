module MeasurementDetails::Representer
  class Index < Abstract::Representer
    collection :MeasurementDetails, decorator: Show
  end
end
