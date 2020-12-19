module Campaigns::Representer
  class Show < Abstract::Representer
    property :id
    property :product_id
    property :platform
    property :store_url
    property :status
    property :note
    property :created_at
    property :updated_at
  end
end
