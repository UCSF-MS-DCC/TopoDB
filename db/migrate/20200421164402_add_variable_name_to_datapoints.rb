class AddVariableNameToDatapoints < ActiveRecord::Migration[5.2]
  def change
    add_column :datapoints, :variable_name, :string
  end
end
