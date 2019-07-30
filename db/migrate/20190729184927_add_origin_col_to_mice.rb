class AddOriginColToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :origin, :string
  end
end
