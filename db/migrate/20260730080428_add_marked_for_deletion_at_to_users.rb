class AddMarkedForDeletionAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :marked_for_deletion_at, :datetime
  end
end
