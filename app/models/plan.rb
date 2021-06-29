class Plan < ApplicationRecord
  DISCOUNTS = { 2 => 5, 3 => 10 }.freeze
  SHIP_DAYS = [10, 20, 30].freeze

  belongs_to :user
  belongs_to :address
  has_many :boxes, dependent: :destroy
  has_many :box_items, through: :boxes
  has_many :shipments, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_validation :set_ship_day

  monetize :price_cents, as: :price
  monetize :shipment_cents, as: :shipment
  monetize :total_price_cents, as: :total_price

  validates :quantity, :total_price_cents, :price_cents, :shipment_cents,
            numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :carrefour_card, :active, inclusion: { in: [true, false] }

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
    boxes.includes(box_item: :carrefour_box)
         .group_by { |box| box.box_item.carrefour_box }.each do |box, items|
      subscription += box.plans[items.first.box_size]['price']
    end
    discounts = calculate_discount(subscription)
    subscription - discounts
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
      location = ViaCep::Address.new(address)
      destination = Geocoder.coordinates(location.street + ' ' + location.city + ' ' + location.state)
      carrefour = Geocoder.coordinates('Av. Doutor Mauro Lindemberg Monteiro, 322')
      shipment_distance = Geocoder::Calculations.distance_between(carrefour, destination)
      shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
    end
  end

  def calculate_discount(subscription)
    if quantity == 1
      0
    elsif quantity > 3
      (subscription * 10) / 100
    else
      (subscription * DISCOUNTS[quantity]) / 100
    end
  end
end
