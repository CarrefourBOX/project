class BoxItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end

  private

  def admin?
    user.admin
  end
end
