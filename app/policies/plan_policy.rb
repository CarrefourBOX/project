class PlanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def toggle_auto_renew?
    user == record.user || admin?
  end

  private

  def admin?
    user.admin
  end
end
