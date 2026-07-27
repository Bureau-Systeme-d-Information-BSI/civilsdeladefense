class AddMarkedForDeletionAtToAdministrators < ActiveRecord::Migration[7.2]
  def change
    add_column :administrators, :marked_for_deletion_at, :datetime
  end
end
