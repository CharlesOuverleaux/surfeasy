class Spot < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :name, presence: true
  validates :surfline_id, presence: true, uniqueness: true
  validates :lat, presence: true
  validates :lon, presence: true
  validates :country, presence: true

  reverse_geocoded_by :lat, :lon
end
