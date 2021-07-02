class CepPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def fetch_address?
    user
  end

  def calculate_shipment?
    user
  end
end
