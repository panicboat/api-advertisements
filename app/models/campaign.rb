class Campaign < ApplicationRecord
  belongs_to :product
  has_many :events,           dependent: :destroy
  has_many :measurements,     dependent: :destroy
  has_many :budget_details, dependent: :destroy

  enum platform: { ios: 1, android: 2 }
  enum status: { available: 1, unavailable: 2 }
end
