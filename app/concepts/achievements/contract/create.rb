module Achievements::Contract
  class Create < Abstract::Contract
    property  :event_id
    property  :label
    property  :status,    default: 'available'

    validates :event_id,  presence: true, numericality: true
    validates :status,    resence: false, inclusion: { in: ::Achievement.statuses.keys }
  end
end
