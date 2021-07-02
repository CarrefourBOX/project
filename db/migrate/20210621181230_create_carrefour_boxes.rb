class CreateCarrefourBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :carrefour_boxes do |t|
      t.string :name
      t.string :color, null: false, default: ''
      t.text :summary, null: false, default: ''
      t.text :description, null: false, default: ''
      t.jsonb :plans, null: false, default: {}
      t.float :average_rating, precision: 2, scale: 1

      t.timestamps
    end
  end
end
