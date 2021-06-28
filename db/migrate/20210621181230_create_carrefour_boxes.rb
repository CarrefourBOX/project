class CreateCarrefourBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :carrefour_boxes do |t|
      t.string :name
      t.string :color, null: false, default: ''
      t.text :description, null: false, default: ''
      t.jsonb :plans, null: false, default: {}

      t.timestamps
    end
  end
end
