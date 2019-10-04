# frozen_string_literal: true

class AddNoteToPreferredUsersList < ActiveRecord::Migration[5.2]
  def change
    add_column :preferred_users_lists, :note, :text
  end
end
