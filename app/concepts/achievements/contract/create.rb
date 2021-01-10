module Achievements::Contract
  class Create < Abstract::Contract
    property  :event_id
    property  :label
    property  :default
    property  :status,    default: 'available'

    validates :event_id,  presence: true, numericality: true
    validates :default,   presence: true, inclusion: { in: %w[true false] }
    validates :status,    resence: false, inclusion: { in: ::Achievement.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:event_default, I18n.t('errors.messages.taken')) if default == 'true' && ::Achievement.where.not({ id: id }).where({ event_id: event_id, default: true }).present?
    end
  end
end
