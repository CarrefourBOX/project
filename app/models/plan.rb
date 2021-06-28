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
  has_many :boxes, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_one :order

  before_validation :calculate_price, :calculate_mensal_price, :calculate_shipment, :calculate_expiration, :set_ship_day

  monetize :price_cents, as: 'price'
  monetize :mensal_price_cents, as: 'mensal_price'
  monetize :shipment_cents, as: 'shipment'

  geocoded_by :address
  after_validation :geocode


  validates :category, presence: true,
                       inclusion: { in: CATEGORIES.keys }
  validates :price_cents, presence: true
  validates :mensal_price_cents, presence: true
  validates :shipment_cents, presence: true
  validates :ship_day, presence: true,
                       inclusion: { in: SHIP_DAYS }
  validates :carrefour_card, inclusion: { in: [true, false] }
  validates :auto_renew, inclusion: { in: [true, false] }
  validates :quantity, presence: true

  private

  def calculate_price
    total_price = (CATEGORIES[category][0] * CATEGORIES[category][1]) * quantity
    discounts = quantity == 1 ? 0 : (total_price * DISCOUNTS[quantity]) / 100
    self.price_cents = total_price - discounts
  end

  def calculate_mensal_price
    self.mensal_price_cents = price_cents / CATEGORIES[category][1]
  end

  def calculate_expiration
    time = created_at || Time.now
    self.expires_at = Time.at(time) + CATEGORIES[category][1].months
  end

  def set_ship_day
    day = created_at ? created_at.day : Time.now.day
    self.ship_day = if day >= 9 && day <= 18
                      '20'
                    elsif day >= 19 && day <= 28
                      '30'
                    else
                      '10'
                    end
  end

  def calculate_shipment
    destination = Geocoder.coordinates(self.address)
    carrefour = Geocoder.coordinates('Av. Doutor Mauro Lindemberg Monteiro, 322')
    shipment_distance = Geocoder::Calculations.distance_between(carrefour, destination)
    if shipment_distance < 100
      self.shipment_cents = 1499
    else
      self.shipment_cents = 1499 + shipment_distance.round
    end
  end
end
