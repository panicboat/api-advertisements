module Banners::Contract
  class Update < Abstract::Contract
    property  :id
    property  :product_id
    property  :label
    property  :classification
    property  :status, default: 'available'

    validates :id,              presence: true, numericality: true
    validates :product_id,      presence: true, numericality: true
    validates :classification,  presence: true, inclusion: { in: ::Banner.classifications.keys }
    validates :status,          presence: false, inclusion: { in: ::Banner.statuses.keys }
  end
end
