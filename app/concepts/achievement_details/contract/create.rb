module AchievementDetails::Contract
  class Create < Abstract::Contract
    property  :achievement_id
    property  :start_at
    property  :end_at
    property  :charge
    property  :payment
    property  :commission

    validates :achievement_id,  presence: true, numericality: true
    validates :start_at,        presence: false
    validates :end_at,          presence: false
    validates :charge,          presence: true, numericality: true
    validates :payment,         presence: true, numericality: true
    validates :commission,      presence: true, numericality: true
    validate  :consistence
    validate  :uniqueness

    def consistence
      errors.add(:total_amount, I18n.t('errors.messages.invalid')) if (charge.blank? ? 0 : charge.to_f) != (payment.blank? ? 0 : payment.to_f) + (commission.blank? ? 0 : commission.to_f)
    end

    def uniqueness
      model = ::AchievementDetail.where({ achievement_id: achievement_id })
      errors.add(:start_at, I18n.t('errors.messages.taken')) if model.where({ start_at: start_at }).present?
      errors.add(:period, I18n.t('errors.messages.taken')) if start_at.present? && end_at.present? && model.where('start_at <= ?', end_at).where('? <= end_at', start_at).present?
    end
  end
end
