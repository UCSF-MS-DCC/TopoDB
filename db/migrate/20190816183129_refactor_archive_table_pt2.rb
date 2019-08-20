class RefactorArchiveTablePt2 < ActiveRecord::Migration[5.2]
  def change
    change_column :archives, :cage, 'integer USING cage::integer'
    change_column :archives, :mouse, 'integer USING mouse::integer'
    change_column :archives, :who, 'integer USING who::integer'
  end
end
