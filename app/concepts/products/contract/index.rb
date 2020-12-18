module Products::Contract
  class Index < Abstract::Contract
    property  :advertiser_id

    validates :advertiser_id, allow_blank: true, numericality: true
  end
end
