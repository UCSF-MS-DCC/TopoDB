class AddGenotypesToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :genotype, :string
    add_column :cages, :genotype2, :string
    add_column :cages, :strain2, :string
  end
end
