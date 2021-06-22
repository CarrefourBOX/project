class Box < ApplicationRecord
  belongs_to :plan
  belongs_to :box_item
end
