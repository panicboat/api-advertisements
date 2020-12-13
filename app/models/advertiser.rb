class Advertiser < ApplicationRecord
  belongs_to :agency, optional: true
  has_many :products, dependent: :destroy
end
