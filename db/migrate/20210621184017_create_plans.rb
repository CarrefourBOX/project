class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.boolean :carrefour_card, null: false, default: false
      t.string :category, null: false
      t.monetize :price, null: false
      t.monetize :shipment, null: false
      t.references :user, foreign_key: true
      t.boolean :auto_renew, null: false, default: true
      t.integer :quantity, null: false
      t.text :ship_day, null: false, default: ''

      t.timestamps
    end
  end
end
