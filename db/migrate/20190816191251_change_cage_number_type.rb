class ChangeCageNumberType < ActiveRecord::Migration[5.2]
  def change
    change_column :cages, :cage_number, :string
  end
end
