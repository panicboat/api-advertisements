class Measurement < ApplicationRecord
  belongs_to :campaign
  has_many :measurement_details,    dependent: :destroy
  has_many :measurement_principals, dependent: :destroy

  enum status: { available: 1, unavailable: 2 }
end
