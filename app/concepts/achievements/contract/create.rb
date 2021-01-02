module Achievements::Contract
  class Create < Abstract::Contract
    property  :label
    property  :status,          default: 'available'

    validates :status,          presence: false, inclusion: { in: ::Achievement.statuses.keys }
  end
end
