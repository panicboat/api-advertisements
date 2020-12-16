module Agencies::Contract
  class Destroy < Abstract::Contract
    property  :id

    validates :id, numericality: true, allow_blank: false
  end
end
