class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def dashboard?
    admin?
  end

  def my_boxes?
    user
  end

  private

  def admin?
    user.admin
  end
end
