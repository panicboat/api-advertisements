module Advertisers::Contract
  class Create < Abstract::Contract
    property  :agency_id
    property  :name
    property  :url
    property  :representative
    property  :contact
    property  :note

    validates :agency_id,       allow_blank: true, numericality: true
    validates :name,            presence: true
    validates :url,             presence: true, format: { with: FORMAT_URL }
    validate  :uniqueness

    def uniqueness
      errors.add(:url, I18n.t('errors.messages.taken')) if ::Advertiser.where.not({ id: id }).where({ url: url }).present?
    end
  end
end
