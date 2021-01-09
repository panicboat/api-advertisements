module BannerDetails::Contract
  class Update < Abstract::Contract
    property  :id
    property  :banner_id
    property  :start_at
    property  :end_at
    property  :url

    validates :id,              presence: true, numericality: true
    validates :banner_id,       presence: true, numericality: true
    validates :start_at,        presence: false
    validates :end_at,          presence: false
    validates :url,             presence: true, format: { with: FORMAT_URL }
    validate  :uniqueness

    def uniqueness
      model = ::BannerDetail.where.not({ id: id }).where({ banner_id: banner_id })
      errors.add(:start_at, I18n.t('errors.messages.taken')) if model.where({ start_at: start_at }).present?
      errors.add(:period, I18n.t('errors.messages.taken')) if start_at.present? && end_at.present? && model.where('start_at <= ?', end_at).where('? <= end_at', start_at).present?
    end
  end
end
