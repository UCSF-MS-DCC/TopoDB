class CreateArchives < ActiveRecord::Migration[5.2]
  def change
    create_table :archives do |t|
      t.string :objdsn
      t.string :objtype
      t.string :objattr
      t.string :acttype
      t.string :priorval
      t.string :newval
      t.string :who

      t.timestamps
    end
  end
end
