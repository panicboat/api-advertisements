module BannerDetails::Contract
  class Index < Abstract::Contract
    property  :banner_id

    validates :banner_id, allow_blank: true, numericality: true
  end
end
