class CampaignPrincipal < ApplicationRecord
  belongs_to :campaign

  has_many :achievement_principals, dependent: :destroy
  has_many :measurement_principals, dependent: :destroy
end
