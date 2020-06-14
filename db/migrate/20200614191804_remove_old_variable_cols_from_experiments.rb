class RemoveOldVariableColsFromExperiments < ActiveRecord::Migration[5.2]
  def change
    remove_column :experiments, :variable_1
    remove_column :experiments, :variable_1_rows
    remove_column :experiments, :variable_2
    remove_column :experiments, :variable_2_rows
    remove_column :experiments, :variable_3
    remove_column :experiments, :variable_3_rows
  end
end
