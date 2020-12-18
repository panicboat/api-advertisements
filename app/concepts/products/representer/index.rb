module Products::Representer
  class Index < Abstract::Representer
    collection :Products, decorator: Show
  end
end
