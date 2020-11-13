module Advertisers::Contract
  class Destroy < Abstract::Contract
    property  :id

    validates :id, presence: true, numericality: { only_integer: true }
  end
end
