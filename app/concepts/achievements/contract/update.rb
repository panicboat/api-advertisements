module Achievements::Contract
  class Update < Abstract::Contract
    property  :id
    property  :label
    property  :status,  default: 'available'

    validates :id,      presence: true, numericality: true
    validates :status,  presence: false, inclusion: { in: ::Achievement.statuses.keys }
  end
end
