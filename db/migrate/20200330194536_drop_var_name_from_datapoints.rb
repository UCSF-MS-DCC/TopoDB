class DropVarNameFromDatapoints < ActiveRecord::Migration[5.2]
  def change
    remove_column :datapoints, :var_name
  end
end
