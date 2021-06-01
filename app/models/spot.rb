class Spot < ApplicationRecord
  validates :name, presence: true
  validates :surfline_id, presence: true, uniqueness: true
  validates :lat, presence: true
  validates :lon, presence: true
  validates :country, presence: true
end
