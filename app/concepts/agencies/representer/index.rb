module Agencies::Representer
  class Index < Abstract::Representer
    collection :Agencies, decorator: Show
  end
end
