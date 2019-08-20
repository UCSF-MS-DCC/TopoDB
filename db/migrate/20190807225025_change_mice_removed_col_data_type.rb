class ChangeMiceRemovedColDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :mice, :removed, 'date'
  end
end
