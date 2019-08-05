class AddInUseColToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :in_use, :boolean
  end
end
