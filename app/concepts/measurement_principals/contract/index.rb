module MeasurementPrincipals::Contract
  class Index < Abstract::Contract
    property  :campaign_principal_id

    validates :campaign_principal_id, allow_blank: true, numericality: true
  end
end
