class Plan < ApplicationRecord
  CATEGORIES = {
    'Mensal' => 1,
    'Trimestral' => 3,
    'Semestral' => 6,
    'Anual' => 12
  }.freeze
  SHIP_DAYS = [10, 20, 30].freeze

  belongs_to :user
  has_many :boxes, dependent: :destroy
  has_many :box_items, through: :boxes
  has_many :carrefour_boxes, through: :box_items
  has_many :shipments, dependent: :destroy
  has_one :order, dependent: :destroy

  before_validation :set_ship_day, :calculate_expiration

  monetize :price_cents, as: 'price'
  monetize :monthly_price_cents, as: 'monthly_price'
  monetize :shipment_cents, as: 'shipment'

  geocoded_by :address
  after_validation :geocode

  validates :category, presence: true,
                       inclusion: { in: CATEGORIES }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 },
                       allow_blank: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 },
                          allow_blank: true
  validates :monthly_price_cents, numericality: { greater_than_or_equal_to: 0 },
                                  allow_blank: true
  validates :shipment_cents, numericality: { greater_than_or_equal_to: 0 },
                             allow_blank: true
  validates :carrefour_card, inclusion: { in: [true, false] }
  validates :auto_renew, inclusion: { in: [true, false] }
  validates :active, inclusion: { in: [true, false] }

  def self.discount_hash
    { 2 => 0.05, 3 => 0.1 }.freeze
  end

  def self.discounts(num)
    Plan.discount_hash.keys.include?(num) ? (1 - Plan.discount_hash[num]) : 1
  end

  def calculate_total
    price = calculate_total_price
    update(
      price_cents: price,
      monthly_price_cents: price / CATEGORIES[category],
      shipment_cents: calculate_shipment
    )
  end

  private

  def calculate_total_price
    total_price = 0
    box_items.includes(:carrefour_box).group_by(&:carrefour_box).each_key do |box|
      total_price += box.plans[category]['price'] * CATEGORIES[category]
    end
    total_price * Plan.discounts(quantity)
  end

  def calculate_expiration
    time = created_at || Time.now
    self.expires_at = Time.at(time) + CATEGORIES[category].months
  end

  def set_ship_day
    day = created_at ? created_at.day : Time.now.day
    self.ship_day = if day >= 9 && day <= 18
                      20
                    elsif day >= 19 && day <= 28
                      30
                    else
                      10
                    end
  end

  def calculate_shipment
    location = ViaCep::Address.new(address)
    destination = Geocoder.coordinates(location.street + ' ' + location.city + ' ' + location.state)
    carrefour = Geocoder.coordinates('Av. Doutor Mauro Lindemberg Monteiro, 322')
    shipment_distance = Geocoder::Calculations.distance_between(carrefour, destination)
    shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
  end
end
