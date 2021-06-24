class AddExpiresAtToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :expires_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
