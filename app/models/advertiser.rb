class Advertiser < ApplicationRecord
  belongs_to :agency
  has_many :products, dependent: :destroy
end
