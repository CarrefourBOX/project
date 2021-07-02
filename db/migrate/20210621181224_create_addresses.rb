class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.string :name, null: false, default: ''
      t.boolean :main, null: false, default: false
      t.string :cep, null: false, default: ''
      t.string :street, null: false, default: ''
      t.string :number, null: false, default: ''
      t.string :complements
      t.string :state, null: false, default: ''
      t.string :city, null: false, default: ''
      t.string :full_address, null: false, default: ''
      t.float :latitude
      t.float :longitude
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
