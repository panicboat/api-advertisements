module Measurements::Contract
  class Create < Abstract::Contract
    property  :campaign_id
    property  :label
    property  :default
    property  :status,          default: 'available'

    validates :campaign_id,     presence: true, numericality: true
    validates :default,         presence: true, inclusion: { in: %w[true false] }
    validates :status,          presence: false, inclusion: { in: ::Measurement.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:campaign_default, I18n.t('errors.messages.taken')) if default == 'true' && ::Measurement.where.not({ id: id }).where({ campaign_id: campaign_id, default: true }).present?
    end
  end
end
