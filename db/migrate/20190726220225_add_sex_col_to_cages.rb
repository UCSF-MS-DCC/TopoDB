class AddSexColToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :sex, :string
  end
end
