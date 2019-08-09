class AddRemovedForColToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :removed_for, :text
  end
end
