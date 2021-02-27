module AchievementPrincipals::Representer
  class Show < Abstract::Representer
    property :id
    property :campaign_principal_id
    property :achievement_id
    property :created_at
    property :updated_at
  end
end
