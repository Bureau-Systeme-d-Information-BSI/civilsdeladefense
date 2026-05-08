class AddAceAteToAdministrators < ActiveRecord::Migration[7.1]
  def change
    add_column :administrators, :ace, :boolean, default: false
    add_column :administrators, :ate, :boolean, default: false
  end
end
