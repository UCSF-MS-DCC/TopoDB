class AddVariableNameColToDatapoints < ActiveRecord::Migration[5.2]
  def change
    add_column :datapoints, :var_name, :text
  end
end
