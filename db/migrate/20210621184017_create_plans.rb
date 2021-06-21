class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.boolean :carrefour_card, null: false, default: false
      t.integer :category, null: false, default: 0
      t.integer :price, null: false, default: 0
      t.integer :shipment, null: false, default: 0
      t.string :user_id, null: false, default: ''
      t.boolean :auto_renew, null: false, default: true
      t.integer :quantity, null: false, default: 0
      t.text :ship_day, null: false, default: ''

      t.timestamps
    end
    add_index :plans, :user_id
  end
end
