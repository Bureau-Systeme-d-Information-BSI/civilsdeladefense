class AddVeryFirstAccountToAdministrators < ActiveRecord::Migration[5.2]
  def change
    add_column :administrators, :very_first_account, :boolean, default: false
  end
end
