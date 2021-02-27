module MeasurementPrincipals::Contract
  class Create < Abstract::Contract
    property  :campaign_principal_id
    property  :measurement_id

    validates :campaign_principal_id, presence: true, numericality: true
    validates :measurement_id,        presence: true, numericality: true
    validate  :uniqueness

    def uniqueness
      errors.add(:measurement_principal, I18n.t('errors.messages.taken')) if ::MeasurementPrincipal.where.not({ id: id }).where({ campaign_principal_id: campaign_principal_id, measurement_id: measurement_id }).present?
    end
  end
end
