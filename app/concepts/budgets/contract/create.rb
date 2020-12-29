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
    validate  :datetime
    validate  :uniqueness

    def datetime
      return if start_at.blank? || end_at.blank?

      begin
        DateTime.parse(start_at.to_s)
      rescue ArgumentError
        errors.add(:start_at, 'must be a valid datetime')
      end
      begin
        DateTime.parse(end_at.to_s)
      rescue ArgumentError
        errors.add(:end_at, 'must be a valid datetime')
      end
    end

    def uniqueness
      errors.add(:period, 'are overlapping') if ::Budget.where({ product_id: product_id }).where('start_at <= ?', end_at).where('? <= end_at', start_at).present?
    end
  end
end
