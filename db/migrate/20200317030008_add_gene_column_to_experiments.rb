class AddGeneColumnToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :gene, :string
  end
end
