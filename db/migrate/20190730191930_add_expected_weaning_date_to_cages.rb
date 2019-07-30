class AddExpectedWeaningDateToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :expected_weaning_date, :date
  end
end
