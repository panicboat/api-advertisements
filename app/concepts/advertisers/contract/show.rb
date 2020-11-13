module Advertisers::Contract
  class Show < Abstract::Contract
    class Show < Abstract::Contract
      property  :id

      validates :id, presence: true, numericality: { only_integer: true }
    end
  end
end
