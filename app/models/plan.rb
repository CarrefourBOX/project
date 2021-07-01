class Plan < ApplicationRecord
  SHIP_DAYS = [10, 20, 30].freeze

  belongs_to :user
  belongs_to :address
  has_many :boxes, dependent: :destroy
  has_many :box_items, through: :boxes
  has_many :carrefour_boxes, through: :box_items
  has_many :shipments, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_validation :set_ship_day

  monetize :price_cents, as: :price
  monetize :shipment_cents, as: :shipment
  monetize :total_price_cents, as: :total_price

  validates :quantity, :total_price_cents, :price_cents, :shipment_cents,
            numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :carrefour_card, :active, inclusion: { in: [true, false] }

  def self.discount_hash
    { 2 => 0.05, 3 => 0.1 }.freeze
  end

  def self.discounts(num)
    Plan.discount_hash.keys.include?(num) ? (1 - Plan.discount_hash[num]) : 1
  end

  def calculate_total
    shipping = calculate_shipment
    subscription = calculate_subscription
    update(
      price_cents: subscription,
      shipment_cents: shipping,
      total_price_cents: subscription + shipping
    )
  end

  private

  def calculate_subscription
    subscription = 0
    boxes.includes(box_item: :carrefour_box).group_by { |box| box.box_item.carrefour_box }.each do |box, items|
      subscription += box.plans[items.first.box_size]['price']
    end
    total_price = subscription * Plan.discounts(quantity)
  end

  def set_ship_day
    day = created_at ? created_at.day : Time.now.day
    self.ship_day = if day >= 6 && day <= 15
                      20
                    elsif day >= 16 && day <= 25
                      30
                    else
                      10
                    end
  end

  def calculate_shipment
    if carrefour_card
      0
    else
      shipment_distance = Geocoder::Calculations.distance_between(CARREFOUR_COORDS, address)
      shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
    end
  end
end
