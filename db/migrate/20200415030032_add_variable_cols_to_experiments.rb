class AddVariableColsToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :variable_1, :text
    add_column :experiments, :variable_1_rows, :integer
    add_column :experiments, :variable_2, :text
    add_column :experiments, :variable_2_rows, :integer
    add_column :experiments, :variable_3, :text
    add_column :experiments, :variable_3_rows, :integer
  end
end
