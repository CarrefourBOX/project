class CarrefourBoxPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end

  def update?
    admin?
  end

  private

  def admin?
    user.admin
  end
end
