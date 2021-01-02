module Achievements::Representer
  class Index < Abstract::Representer
    collection :Achievements, decorator: Show
  end
end
