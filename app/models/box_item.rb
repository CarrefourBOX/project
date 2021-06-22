class BoxItem < ApplicationRecord
  validates :box_name, presence: true,
                       inclusion: { in: BoxName.pluck(:name) }
  validates :item_name, presence: true
end
