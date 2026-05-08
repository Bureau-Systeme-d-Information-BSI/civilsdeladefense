class AddRolesToAdministrators < ActiveRecord::Migration[7.1]
  def change
    add_column :administrators, :roles, :integer, default: 0, null: false
  end
end
