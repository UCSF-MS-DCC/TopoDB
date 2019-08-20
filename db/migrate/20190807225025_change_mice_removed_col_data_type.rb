class ChangeMiceRemovedColDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :mice, :removed, 'date USING removed::date'
  end
end
