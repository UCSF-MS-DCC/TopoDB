class RenameTailCutDateToBiopsyCollectionDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :mice, :tail_cut_date, :biopsy_collection_date
  end
end
