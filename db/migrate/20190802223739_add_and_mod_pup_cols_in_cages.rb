class AddAndModPupColsInCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :pups_m, :integer
    rename_column :cages, :pups, :pups_f
  end
end
