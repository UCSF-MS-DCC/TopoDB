class AddDefaultValuesToUsersColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :admin, :boolean, :default => false 
    change_column :users, :editor, :boolean, :default => false
    #Ex:- :default =>''
  end
end
