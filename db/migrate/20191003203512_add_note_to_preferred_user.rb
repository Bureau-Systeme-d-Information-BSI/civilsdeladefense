# frozen_string_literal: true

class AddNoteToPreferredUser < ActiveRecord::Migration[5.2]
  def change
    add_column :preferred_users, :note, :text
  end
end
