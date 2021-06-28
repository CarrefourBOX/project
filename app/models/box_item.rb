class BoxItem < ApplicationRecord
  belongs_to :carrefour_box
  has_many :boxes, dependent: :destroy

  validates :name, presence: true
end
