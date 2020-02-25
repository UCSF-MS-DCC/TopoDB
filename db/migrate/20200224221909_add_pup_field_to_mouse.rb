class AddPupFieldToMouse < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :pup, :boolean
  end
end
