module Banners::Contract
  class Update < Create
    property  :id

    validates :id, presence: true, numericality: true
  end
end
