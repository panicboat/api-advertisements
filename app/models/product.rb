class Product < ApplicationRecord
  belongs_to :advertiser
  has_many :campaigns, dependent: :destroy
  has_many :banners, dependent: :destroy
  has_many :budgets, dependent: :destroy
end
