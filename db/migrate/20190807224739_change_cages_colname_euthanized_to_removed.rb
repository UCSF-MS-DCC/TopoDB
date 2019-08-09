class ChangeCagesColnameEuthanizedToRemoved < ActiveRecord::Migration[5.2]
  def change
    rename_column :mice, :euthanized, :removed
  end
end
