class AddProtocolToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :protocol, :text
  end
end
