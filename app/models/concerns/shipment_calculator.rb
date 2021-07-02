module ShipmentCalculator
  extend ActiveSupport::Concern

  def self.calculate(destination)
    shipment_distance = Geocoder::Calculations.distance_between(CARREFOUR_COORDS, destination)
    shipment_distance < 100 ? 1499 : 1499 + shipment_distance.round
  end
end
