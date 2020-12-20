module Agencies::Contract
  class Create < Abstract::Contract
    property  :name
    property  :url
    property  :representative
    property  :contact
    property  :note

    validates :name,            presence: true
    validates :url,             presence: true, format: { with: FORMAT_URL }
    validate  :uniqueness

    def uniqueness
      errors.add(:url, I18n.t('errors.messages.taken')) if ::Agency.where({ url: url }).present?
    end
  end
end
