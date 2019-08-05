class RemoveRackAndSpaceFromCages < ActiveRecord::Migration[5.2]
  def change
    remove_column :cages, :rack 
    remove_column :cages, :space
  end
end
