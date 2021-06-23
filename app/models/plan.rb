class Plan < ApplicationRecord
  CATEGORIES = {
    'Mensal' => [9990, 1],
    'Trimestral' => [8990, 3],
    'Semestral' => [7990, 6],
    'Anual' => [6990, 12]
  }.freeze

  DISCOUNTS = { 2 => 5, 3 => 10 }.freeze

  SHIP_DAYS = %w[10 20 30].freeze

  belongs_to :user
  has_many :boxes

  before_validation :calculate_price
  before_validation :calculate_shipment

  monetize :price_cents, as: 'price'
  monetize :shipment_cents, as: 'shipment'

  validates :category, presence: true,
                       inclusion: { in: CATEGORIES.keys }
  validates :price_cents, presence: true
  validates :shipment_cents, presence: true
  validates :ship_day, presence: true,
                       inclusion: { in: SHIP_DAYS }
  validates :carrefour_card, inclusion: { in: [true, false] }
  validates :auto_renew, presence: true
  validates :quantity, presence: true

  private

  def calculate_price
    total_price = (CATEGORIES[category][0] * CATEGORIES[category][1]) * quantity
    discounts = quantity == 1 ? 0 : (total_price * DISCOUNTS[quantity]) / 100
    self.price_cents = total_price - discounts
  end

  def calculate_shipment
    self.shipment_cents = rand(10..20) * 99
  end
end
