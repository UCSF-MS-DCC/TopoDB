class CreateDatapoints < ActiveRecord::Migration[5.2]
  def change
    create_table :datapoints do |t|
      t.references :mouse, foreign_key: true
      t.string :var_name
      t.string :var_value
      t.string :timepoint

      t.timestamps
    end
  end
end
