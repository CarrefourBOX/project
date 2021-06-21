class CreateBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :boxes, id: :uuid do |t|
      t.references :plan, type: :uuid, null: false, foreign_key: true
      t.references :box_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
