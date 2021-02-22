class AchievementPrincipal < ApplicationRecord
  belongs_to :campaign_principal
  belongs_to :achievement
end
