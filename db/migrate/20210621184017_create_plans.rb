class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :address, type: :uuid, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :ship_day, null: false, default: 1
      t.monetize :price
      t.monetize :shipment
      t.monetize :total_price
      t.boolean :carrefour_card, null: false, default: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
