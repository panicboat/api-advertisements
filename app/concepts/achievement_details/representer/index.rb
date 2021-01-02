module AchievementDetails::Representer
  class Index < Abstract::Representer
    collection :AchievementDetails, decorator: Show
  end
end
