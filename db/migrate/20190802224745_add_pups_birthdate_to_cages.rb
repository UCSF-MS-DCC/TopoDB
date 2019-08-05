class AddPupsBirthdateToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :pups_birthdate, :date
  end
end
