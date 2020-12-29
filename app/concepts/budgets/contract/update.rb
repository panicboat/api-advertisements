module Budgets::Contract
  class Update < Abstract::Contract
    property  :id
    property  :product_id
    property  :label
    property  :start_at
    property  :end_at
    property  :amount
    property  :status, default: 'available'

    validates :id,          presence: true, numericality: true
    validates :product_id,  presence: true, numericality: true
    validates :start_at,    presence: true
    validates :end_at,      presence: true
    validates :amount,      presence: true, numericality: true
    validates :status,      presence: false, inclusion: { in: ::Budget.statuses.keys }
    validate  :uniqueness

    def uniqueness
      errors.add(:period, 'is overlapping') if ::Budget.where.not({ id: id }).where({ product_id: product_id }).where('start_at <= ?', end_at).where('? <= end_at', start_at).present?
    end
  end
end
