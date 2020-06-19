class AddLastViewedToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :last_viewed, :datetime
  end
end
