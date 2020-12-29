module Events::Representer
  class Index < Abstract::Representer
    collection :Events, decorator: Show
  end
end
