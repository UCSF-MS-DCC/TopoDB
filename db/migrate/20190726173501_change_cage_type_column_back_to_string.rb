class ChangeCageTypeColumnBackToString < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :cage_type, :string
  end
end
