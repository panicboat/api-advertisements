class MapEventAchievement < ApplicationRecord
  belongs_to :event
  belongs_to :achievement

  enum classification: { default: 1, designated: 2 }
end
