class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user == record.user
  end
end
