module BudgetDetails::Contract
  class Destroy < Abstract::Contract
    property  :id

    validates :id, presence: true, numericality: true
  end
end
