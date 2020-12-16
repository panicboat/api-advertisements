module Agencies::Contract
  class Show < Abstract::Contract
    class Show < Abstract::Contract
      property  :id

      validates :id, numericality: true, allow_blank: false
    end
  end
end
