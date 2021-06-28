class AddCoordinatesToPlan < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :address, :text
    add_column :plans, :latitude, :float
    add_column :plans, :longitude, :float
  end
end
