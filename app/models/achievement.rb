class Achievement < ApplicationRecord
  belongs_to  :event
  has_many    :achievement_details, dependent: :destroy

  enum status: { available: 1, unavailable: 2 }
end
