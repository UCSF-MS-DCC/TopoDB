class ChangeCageTypeToEnum < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :cage_type, :integer
  end
end
