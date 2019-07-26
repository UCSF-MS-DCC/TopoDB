class CreateMice < ActiveRecord::Migration[5.2]
  def change
    create_table :mice do |t|
      t.references :cage, foreign_key: true
      t.string :sex
      t.string :genotype
      t.date :dob
      t.date :weaning_date
      t.date :tail_cut_date
      t.string :ear_punch
      t.string :designation
      t.boolean :dead
      t.text :notes
      t.string :on_experiment
      t.integer :parent_cage_id

      t.timestamps
    end
  end
end
