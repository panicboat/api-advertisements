class BudgetDetail < ApplicationRecord
  belongs_to :budget
  belongs_to :campaign
end
