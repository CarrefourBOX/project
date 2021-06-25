class PlanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    owner? || admin?
  end

  def toggle_auto_renew?
    user == record.user || admin?
  end

  def owner?
    user == record.user
  end

  private

  def admin?
    user.admin
  end
end
