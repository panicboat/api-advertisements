module BudgetDetails::Contract
  class Create < Abstract::Contract
    property  :budget_id
    property  :campaign_id
    property  :amount

    validates :budget_id,       presence: true, numericality: true
    validates :campaign_id,     presence: true, numericality: true
    validates :amount,          presence: true, numericality: true
    validate  :consistence
    validate  :uniqueness

    def consistence
      budget_amount = ::Budget.find_by({ id: budget_id }).amount
      detail_amount = ::BudgetDetail.where.not({ id: id }).where({ budget_id: budget_id }).sum(:amount)
      errors.add(:total_amount, I18n.t('errors.messages.invalid')) if (budget_amount.blank? ? 0 : budget_amount.to_f) < (detail_amount.blank? ? 0 : detail_amount.to_f) + (amount.blank? ? 0 : amount.to_f)
    end

    def uniqueness
      errors.add(:campaign_id, I18n.t('errors.messages.taken')) if ::BudgetDetail.where.not({ id: id }).where({ budget_id: budget_id, campaign_id: campaign_id }).present?
    end
  end
end
