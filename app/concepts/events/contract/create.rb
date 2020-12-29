module Events::Contract
  class Create < Abstract::Contract
    property  :campaign_id
    property  :name
    property  :status, default: 'available'
    property  :note

    validates :campaign_id, presence: true, numericality: true
    validates :name,        presence: true
    validates :status,      presence: false, inclusion: { in: ::Event.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:name, I18n.t('errors.messages.taken')) if ::Event.where({ campaign_id: campaign_id, name: name }).present?
    end
  end
end
