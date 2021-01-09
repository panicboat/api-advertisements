module MeasurementDetails::Contract
  class Index < Abstract::Contract
    property  :measurement_id

    validates :measurement_id, allow_blank: true, numericality: true
  end
end
