class ChangeCageLocationToEnum < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :location, :integer
  end
end
