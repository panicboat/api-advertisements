class Event < ApplicationRecord
  belongs_to  :campaign
  has_many    :achievements, dependent: :destroy

  enum status: { available: 1, unavailable: 2 }
end
