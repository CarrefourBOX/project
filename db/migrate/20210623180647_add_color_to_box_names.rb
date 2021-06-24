class AddColorToBoxNames < ActiveRecord::Migration[6.1]
  def change
    add_column :box_names, :color, :string, null: false, default: ''
    add_column :box_names, :description, :text, null: false, default: ''
  end
end
