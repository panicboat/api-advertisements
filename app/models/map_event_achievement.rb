class MapEventAchievement < ApplicationRecord
  belongs_to :event
  belongs_to :achievement
end
