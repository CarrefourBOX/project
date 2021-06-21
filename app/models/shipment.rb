class Shipment < ApplicationRecord
  include ShippingCodeGenerator

  before_create :assign_shipping_code

  belongs_to :plan

  private

  def assign_shipping_code
    self.shipping_code = generate_code
  end
end
