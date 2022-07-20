class AddUniqueIndexToPreferredUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :preferred_users, [:user_id, :preferred_users_list_id], unique: true
  end
end
