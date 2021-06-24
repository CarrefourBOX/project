class BoxItem < ApplicationRecord
  validates :box_name, presence: true
  validates :item_name, presence: true

  has_many :boxes, dependent: :destroy
end
