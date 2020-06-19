class AddRowsToExperiment < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :rows, :integer
  end
end
