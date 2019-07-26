class ChangeCageLocationColBackToString < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :location, :string
  end
end
