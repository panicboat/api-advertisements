module Measurements::Contract
  class Index < Abstract::Contract
    property  :campaign_id

    validates :campaign_id, allow_blank: true, numericality: true
  end
end
