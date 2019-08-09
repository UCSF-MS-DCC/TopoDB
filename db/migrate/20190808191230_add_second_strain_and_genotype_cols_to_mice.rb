class AddSecondStrainAndGenotypeColsToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :genotype2, :string
    add_column :mice, :strain2, :string
  end
end
