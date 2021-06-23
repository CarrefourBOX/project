class BoxName < ApplicationRecord
  validates :name, :description, :color, presence: true
end
