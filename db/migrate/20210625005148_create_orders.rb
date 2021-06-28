class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :plan, type: :uuid, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.string :teddy_sku
      t.monetize :amount, currency: { present: false }
      t.string :checkout_session_id

      t.timestamps
    end
  end
end
