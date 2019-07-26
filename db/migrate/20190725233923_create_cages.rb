class CreateCages < ActiveRecord::Migration[5.2]
  def change
    create_table :cages do |t|
      t.string :strain
      t.string :cage_number
      t.string :cage_type
      t.string :location
      t.string :rack
      t.boolean :cage_number_changed

      t.timestamps
    end
  end
end
