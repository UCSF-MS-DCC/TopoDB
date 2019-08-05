class RenameMouseDeadCol < ActiveRecord::Migration[5.2]
  def change
    rename_column :mice, :dead, :euthanized
  end
end
