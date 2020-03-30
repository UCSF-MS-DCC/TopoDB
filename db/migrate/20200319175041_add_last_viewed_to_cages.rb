class AddLastViewedToCages < ActiveRecord::Migration[5.2]
  def change
    add_column :cages, :last_viewed, :datetime
  end
end
