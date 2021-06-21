class Plan < ApplicationRecord
  CATEGORY = [
    'Mensal',
    'Trimestral',
    'Semestral',
    'Anual'
  ].freeze

  belongs_to :user
  validates :category, presence: true,
                            inclusion: { in: CATEGORY }
  validates :price, presence: true,
  validates :shipment, presence: true,
  validates :ship_day, presence: true,
  validates :carrefour_card, presence: true,
  validates :auto_renew, presence: true,
  validates :quantity, presence: true
end
