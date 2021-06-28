class Shipment < ApplicationRecord
  include ShippingCodeGenerator

  belongs_to :plan

  before_create :assign_shipping_code

  private

  def assign_shipping_code
    self.shipping_code = generate_code
  end
end
