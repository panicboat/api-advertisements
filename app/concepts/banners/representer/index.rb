module Banners::Representer
  class Index < Abstract::Representer
    collection :Banners, decorator: Show
  end
end
