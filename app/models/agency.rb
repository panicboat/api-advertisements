class Agency < ApplicationRecord
  has_many :advertisers, dependent: :destroy
end
