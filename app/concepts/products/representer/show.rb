module Products::Representer
  class Show < Abstract::Representer
    property :id
    property :advertiser_id
    property :name
    property :url
    property :note
    property :created_at
    property :updated_at
  end
end
