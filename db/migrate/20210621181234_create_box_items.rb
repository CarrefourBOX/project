class CreateBoxItems < ActiveRecord::Migration[6.1]
  def change
    create_table :box_items do |t|
      t.string :box_name, null: false, default: ''
      t.string :item_name, null: false, default: ''

      t.timestamps
    end
  end
end
