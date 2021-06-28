class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.string :category, null: false, default: ''
      t.integer :quantity, null: false, default: 0
      t.text :ship_day, null: false, default: ''
      t.monetize :price
      t.monetize :monthly_price
      t.monetize :shipment
      t.boolean :carrefour_card, null: false, default: false
      t.boolean :auto_renew, null: false, default: true
      t.boolean :active, null: false, default: true
      t.datetime :expires_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
