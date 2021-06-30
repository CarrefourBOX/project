class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews, id: :uuid do |t|
      t.references :carrefour_box, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :rating, null: false, default: 0
      t.text :content

      t.timestamps
    end
  end
end
