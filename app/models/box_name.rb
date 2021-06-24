class BoxName < ApplicationRecord
  validates :name, :description, :color, presence: true
  validates :name, uniqueness: true

  has_one_attached :icon
end
