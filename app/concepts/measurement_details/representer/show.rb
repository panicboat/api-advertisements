module MeasurementDetails::Representer
  class Show < Abstract::Representer
    property :id
    property :measurement_id
    property :start_at
    property :end_at
    property :url
    property :created_at
    property :updated_at
  end
end
