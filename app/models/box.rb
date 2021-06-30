class Box < ApplicationRecord
  BOX_SIZES = %w[P M G].freeze

  belongs_to :plan
  belongs_to :box_item

  validates :box_size, inclusion: { in: BOX_SIZES }
end
