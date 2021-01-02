module Banners::Contract
  class Index < Abstract::Contract
    property  :product_id

    validates :product_id, allow_blank: true, numericality: true
  end
end
