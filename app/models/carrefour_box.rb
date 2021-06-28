class CarrefourBox < ApplicationRecord
  validates :name, :description, :color, presence: true
  validates :name, uniqueness: true

  has_many :box_items, dependent: :destroy
  has_one_attached :icon
end
