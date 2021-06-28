class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews, id: :uuid do |t|
      t.integer :rating
      t.text :content
      t.references :carrefour_box, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
