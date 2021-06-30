class CarrefourBox < ApplicationRecord
  has_many :box_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :icon

  validates :name, :description, :color, presence: true
  validates :name, uniqueness: true
end
