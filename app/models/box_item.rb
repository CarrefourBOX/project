class BoxItem < ApplicationRecord
  BOX_NAMES = [
    'Happy Hour',
    'Beleza e Cuidado',
    'Receita Certa'
  ].freeze

  validates :box_name, presence: true,
                       inclusion: { in: BOX_NAMES }
  validates :item_name, presence: true
end
