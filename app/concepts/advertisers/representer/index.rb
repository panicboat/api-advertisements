module Advertisers::Representer
  class Index < Abstract::Representer
    collection :Advertisers, decorator: Show
  end
end
