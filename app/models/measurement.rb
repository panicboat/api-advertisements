class Measurement < ApplicationRecord
  belongs_to :campaign
  has_many :measurement_details, dependent: :destroy

  enum type: { default: 1, designated: 2 }
  enum status: { available: 1, unavailable: 2 }
end
