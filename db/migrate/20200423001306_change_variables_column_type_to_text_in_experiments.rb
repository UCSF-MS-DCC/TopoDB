class ChangeVariablesColumnTypeToTextInExperiments < ActiveRecord::Migration[5.2]
  def change
    change_column :experiments, :variables, :text
  end
end
