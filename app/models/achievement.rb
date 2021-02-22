class Achievement < ApplicationRecord
  belongs_to  :event
  has_many    :achievement_details,     dependent: :destroy
  has_many    :achievement_principals,  dependent: :destroy

  enum status: { available: 1, unavailable: 2 }
end
