class AddNumberPupsToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :pups, :integer
  end
end
