module Campaigns::Contract
  class Show < Abstract::Contract
    class Show < Abstract::Contract
      property  :id

      validates :id, presence: true, numericality: true
    end
  end
end
