module Advertisers::Representer
  class Show < Abstract::Representer
    property :id
    property :agency_id
    property :name
    property :url
    property :representative
    property :contact
    property :note
    property :created_at
    property :updated_at
  end
end
