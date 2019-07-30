class AddFirstLastAndEditorFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first, :string
    add_column :users, :last, :string
    add_column :users, :editor, :boolean
  end
end
