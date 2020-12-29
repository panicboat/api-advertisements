module Events::Representer
  class Show < Abstract::Representer
    property :id
    property :name
    property :status
    property :note
    property :created_at
    property :updated_at
  end
end
