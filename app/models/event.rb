class Event < ApplicationRecord
  belongs_to  :campaign
  has_many :map_event_achievements, dependent:  :destroy
  has_many :achievements,           through:    :map_event_achievements

  enum status: { available: 1, unavailable: 2 }
end
