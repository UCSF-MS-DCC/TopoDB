class AddStrainToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :strain, :string
  end
end
