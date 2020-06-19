class AddExperimentCodeToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :experiment_code, :string
  end
end
