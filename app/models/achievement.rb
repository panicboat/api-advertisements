class Achievement < ApplicationRecord
  has_many :map_event_achievements, dependent:  :destroy
  has_many :events,                 through:    :map_event_achievements

  enum type: { default: 1, designated: 2 }
  enum status: { available: 1, unavailable: 2 }
end
