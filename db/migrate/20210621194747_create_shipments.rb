class CreateShipments < ActiveRecord::Migration[6.1]
  def change
    create_table :shipments, id: :uuid do |t|
      t.references :plan, type: :uuid, foreign_key: true
      t.string :shipping_code, null: false, default: ''
      t.monetize :shipping_cost

      t.timestamps
    end
  end
end
