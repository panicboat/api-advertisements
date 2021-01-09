module Achievements::Contract
  class Index < Abstract::Contract
    property  :event_id

    validates :event_id, allow_blank: true, numericality: true
  end
end
