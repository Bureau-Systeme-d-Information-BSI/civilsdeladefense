class AddMarkedForDeactivationOnToAdministrator < ActiveRecord::Migration[6.1]
  def change
    add_column :administrators, :marked_for_deactivation_on, :date
  end
end
