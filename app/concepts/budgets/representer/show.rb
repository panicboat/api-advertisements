module Budgets::Representer
  class Show < Abstract::Representer
    property :id
    property :label
    property :start_at
    property :end_at
    property :amount
    property :status
    property :created_at
    property :updated_at
  end
end
