class RefactorArchiveTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :archives, :objdsn, :cage
    rename_column :archives, :objtype, :mouse
    rename_column :archives, :objattr, :changed_attr
  end
end
