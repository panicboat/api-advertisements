class Product < ApplicationRecord
  belongs_to :advertiser
  has_many :campaigns
  has_many :banners
  has_many :budgets
end
