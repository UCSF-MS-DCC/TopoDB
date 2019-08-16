class RefactorArchiveTablePt2 < ActiveRecord::Migration[5.2]
  def change
    change_column :archives, :cage, :integer
    change_column :archives, :mouse, :integer
    change_column :archives, :who, :integer
  end
end
