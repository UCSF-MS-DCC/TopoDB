class AddDefaultValToCagesInUseCol < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :in_use, :boolean, :default => true
  end
end
