module Advertisers::Contract
  class Create < Abstract::Contract
    property  :agency_id
    property  :name
    property  :url
    property  :representative
    property  :contact
    property  :note

    validates :agency_id,       presence: false, numericality: { only_integer: true }
    validates :name,            presence: true
    validates :url,             presence: true
    validate  :uniqueness

    def uniqueness
      # validates_uniqueness_of :name, scope: [:service_id]
      errors.add(:url, I18n.t('errors.messages.taken')) if ::Advertiser.where({ url: url }).present?
    end
  end
end
