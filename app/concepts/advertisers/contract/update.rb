module Advertisers::Contract
  class Update < Abstract::Contract
    property  :id
    property  :agency_id
    property  :name
    property  :url
    property  :representative
    property  :contact
    property  :note

    validates :id,              presence: true, numericality: true
    validates :agency_id,       allow_blank: true, numericality: true
    validates :name,            presence: true
    validates :url,             presence: true
    validate  :uniqueness

    def uniqueness
      # validates_uniqueness_of :name, scope: [:service_id]
      errors.add(:url, I18n.t('errors.messages.taken')) if ::Advertiser.where.not({ id: id }).where({ url: url }).present?
    end
  end
end
