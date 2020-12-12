module Advertisers::Contract
  class Index < Abstract::Contract
    property  :agency_id

    validates :agency_id, numericality: true, allow_blank: true
  end
end
