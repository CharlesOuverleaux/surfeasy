class Review < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true , length: { minimum: 10 }
  validates :rating, presence: true, :inclusion => { :in => 1..5 }
end
