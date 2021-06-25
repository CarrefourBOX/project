class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    owner?
  end

  def confirm_payment?
    owner?
  end

  private

  def owner?
    user == record.user
  end
end
