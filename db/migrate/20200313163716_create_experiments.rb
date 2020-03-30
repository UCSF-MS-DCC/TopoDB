class CreateExperiments < ActiveRecord::Migration[5.2]
  def change
    create_table :experiments do |t|
      t.string :name
      t.date :date
      t.text :description

      t.timestamps
    end
  end
end
