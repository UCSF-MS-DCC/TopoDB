class AddDefaultValueToCagesGenotypesCols < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :genotype, :string, :default => "0"
    change_column :cages, :genotype2, :string, :default => "0"
  end
end
