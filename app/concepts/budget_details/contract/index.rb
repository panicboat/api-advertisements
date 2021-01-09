module BudgetDetails::Contract
  class Index < Abstract::Contract
    property  :budget_id

    validates :budget_id, allow_blank: true, numericality: true
  end
end
