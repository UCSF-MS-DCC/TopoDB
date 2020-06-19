class AddExperimentIndexToMice < ActiveRecord::Migration[5.2]
  def change
    add_reference :mice, :experiment, foreign_key: true
  end
end
