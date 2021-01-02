module Measurements::Representer
  class Index < Abstract::Representer
    collection :Measurements, decorator: Show
  end
end
