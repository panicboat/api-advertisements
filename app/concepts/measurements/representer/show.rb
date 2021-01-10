module Measurements::Representer
  class Show < Abstract::Representer
    property :id
    property :label
    property :default
    property :status
    property :created_at
    property :updated_at
  end
end
