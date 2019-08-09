class AddThreeDigitCodeToMice < ActiveRecord::Migration[5.2]
  def change
    add_column :mice, :three_digit_code, :string
  end
end
