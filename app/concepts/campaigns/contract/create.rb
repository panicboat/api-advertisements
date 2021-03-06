module Campaigns::Contract
  class Create < Abstract::Contract
    property  :product_id
    property  :platform
    property  :store_url
    property  :status, default: 'available'
    property  :note

    validates :product_id,  presence: true, numericality: true
    validates :platform,    presence: true, inclusion: { in: ::Campaign.platforms.keys }
    validates :store_url,   presence: true, format: { with: FORMAT_URL }
    validates :status,      presence: false, inclusion: { in: ::Campaign.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:store_url, I18n.t('errors.messages.taken'))  if ::Campaign.where.not({ id: id }).where({ platform: platform, store_url: store_url }).present?
    end
  end
end
