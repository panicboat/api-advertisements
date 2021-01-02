module AchievementDetails::Contract
  class Index < Abstract::Contract
    property  :achievement_id

    validates :achievement_id, allow_blank: true, numericality: true
  end
end
