module AchievementDetails::Representer
  class Show < Abstract::Representer
    property :id
    property :achievement_id
    property :start_at
    property :end_at
    property :charge
    property :payment
    property :commission
    property :created_at
    property :updated_at
  end
end
