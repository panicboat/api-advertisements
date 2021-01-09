module BudgetDetails::Contract
  class Update < Create
    property  :id

    validates :id, presence: true, numericality: true
  end
end
