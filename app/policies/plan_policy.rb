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
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  def update_my_box?
    owner?
  end

  def cancel_box?
    owner?
  end

  def owner?
    user == record.user
  end

  private

  def admin?
    user.admin
  end
end
