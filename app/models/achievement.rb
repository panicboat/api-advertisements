class Achievement < ApplicationRecord
  has_many :achievement_details,    dependent:  :destroy
  has_many :map_event_achievements, dependent:  :destroy
  has_many :events,                 through:    :map_event_achievements

  enum status: { available: 1, unavailable: 2 }
end
