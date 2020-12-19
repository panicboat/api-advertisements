module Campaigns::Representer
  class Index < Abstract::Representer
    collection :Campaigns, decorator: Show
  end
end
