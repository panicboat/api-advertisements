class Budget < ApplicationRecord
  belongs_to :product
  has_many :budget_details, dependent: :destroy

  enum status: { available: 1, unavailable: 2 }
end
