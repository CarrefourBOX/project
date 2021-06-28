class CreateBoxItems < ActiveRecord::Migration[6.1]
  def change
    create_table :box_items do |t|
      t.references :carrefour_box, null: false, foreign_key: true
      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
