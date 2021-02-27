module AchievementPrincipals::Representer
  class Index < Abstract::Representer
    collection :AchievementPrincipals, decorator: Show
  end
end
