module Measurements::Contract
  class Update < Abstract::Contract
    property  :id
    property  :campaign_id
    property  :label
    property  :classification,  default: 'default'
    property  :status,          default: 'available'

    validates :id,              presence: true, numericality: true
    validates :campaign_id,     presence: true, numericality: true
    validates :classification,  presence: false, inclusion: { in: ::Measurement.classifications.keys }
    validates :status,          presence: false, inclusion: { in: ::Measurement.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:classification, I18n.t('errors.messages.taken')) if classification == 'default' && ::Measurement.where.not({ id: id }).where({ campaign_id: campaign_id, classification: classification }).present?
    end
  end
end
