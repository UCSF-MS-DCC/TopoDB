class MoveStrainColFromCagesToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :strain, :string 
    remove_column :cages, :strain 
  end
end
