module Products::Contract
  class Create < Abstract::Contract
    property  :advertiser_id
    property  :name
    property  :url
    property  :note

    validates :advertiser_id, presence: true, numericality: true
    validates :name,          presence: true
    validates :url,           presence: true, format: { with: FORMAT_URL }
    validate  :uniqueness

    def uniqueness
      errors.add(:url, I18n.t('errors.messages.taken'))  if ::Product.where.not({ id: id }).where({ url: url }).present?
    end
  end
end
