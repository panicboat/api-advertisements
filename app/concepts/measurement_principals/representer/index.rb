module MeasurementPrincipals::Representer
  class Index < Abstract::Representer
    collection :MeasurementPrincipals, decorator: Show
  end
end
