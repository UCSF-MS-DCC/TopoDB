class RenameExperimentMousesToDatapoints < ActiveRecord::Migration[5.2]
  def change
    drop_table :experiment_mouses
  end
end
