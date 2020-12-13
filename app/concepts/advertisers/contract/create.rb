module Advertisers::Contract
  class Create < Abstract::Contract
    property  :agency_id
    property  :name
    property  :url
    property  :representative
    property  :contact
    property  :note

    validates :agency_id,       numericality: true, allow_blank: true
    validates :name,            presence: true
    validates :url,             presence: true
    validate  :uniqueness

    def uniqueness
      errors.add(:url, I18n.t('errors.messages.taken')) if ::Advertiser.where({ url: url }).present?
    end
  end
end
