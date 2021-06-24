class AddPaymentToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :payment, :boolean, default: false
  end
end
