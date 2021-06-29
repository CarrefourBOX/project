class Shipment < ApplicationRecord
  include ShippingCodeGenerator

  belongs_to :plan

  before_create :assign_shipping_code

  monetize :shipping_cost_cents, as: :shipping_cost

  validates :shipping_cost_cents, numericality: { greater_than_or_equal_to: 0 }

  private

  def assign_shipping_code
    self.shipping_code = generate_code
  end
end
