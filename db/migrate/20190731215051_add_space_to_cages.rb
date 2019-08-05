class AddSpaceToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :space, :string
  end
end
