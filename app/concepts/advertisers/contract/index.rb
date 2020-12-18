module Advertisers::Contract
  class Index < Abstract::Contract
    property  :agency_id

    validates :agency_id, allow_blank: true, numericality: true
  end
end
