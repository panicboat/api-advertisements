module BudgetDetails::Representer
  class Show < Abstract::Representer
    property :id
    property :budget_id
    property :amount
    property :created_at
    property :updated_at
  end
end
