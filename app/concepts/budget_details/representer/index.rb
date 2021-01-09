module BudgetDetails::Representer
  class Index < Abstract::Representer
    collection :BudgetDetails, decorator: Show
  end
end
