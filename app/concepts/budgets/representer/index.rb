module Budgets::Representer
  class Index < Abstract::Representer
    collection :Budgets, decorator: Show
  end
end
