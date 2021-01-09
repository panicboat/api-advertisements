module Budgets::Contract
  class Create < Abstract::Contract
    property  :product_id
    property  :label
    property  :start_at
    property  :end_at
    property  :amount
    property  :status, default: 'available'

    validates :product_id,  presence: true, numericality: true
    validates :start_at,    presence: true
    validates :end_at,      presence: true
    validates :amount,      presence: true, numericality: true
    validates :status,      presence: false, inclusion: { in: ::Budget.statuses.keys }
    validate  :consistence
    validate  :uniqueness

    def consistence
      detail_amount = ::BudgetDetail.where({ budget_id: id }).sum(:amount)
      errors.add(:amount, I18n.t('errors.messages.invalid')) if (amount.blank? ? 0 : amount.to_f) < (detail_amount.blank? ? 0 : detail_amount.to_f)
    end

    def uniqueness
      errors.add(:period, I18n.t('errors.messages.taken')) if ::Budget.where.not({ id: id }).where({ product_id: product_id }).where('start_at <= ?', end_at).where('? <= end_at', start_at).present?
    end
  end
end
