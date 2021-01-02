class Banner < ApplicationRecord
  belongs_to :product
  has_many :banner_details, dependent: :destroy

  enum classification: { image: 1, movie: 2 }
  enum status: { available: 1, unavailable: 2 }
end
