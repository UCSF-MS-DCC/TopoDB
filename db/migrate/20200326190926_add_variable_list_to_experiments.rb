class AddVariableListToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :variables, :string
  end
end
