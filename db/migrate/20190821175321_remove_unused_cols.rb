class RemoveUnusedCols < ActiveRecord::Migration[5.2]
  def change
    remove_column :cages, :pups_f
    remove_column :cages, :pups_m
    remove_column :cages, :pups_birthdate
    remove_column :mice, :origin
    remove_column :mice, :on_experiment
    remove_column :mice, :notes
  end
end
