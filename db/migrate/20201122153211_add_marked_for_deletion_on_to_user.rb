# frozen_string_literal: true

class AddMarkedForDeletionOnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :marked_for_deletion_on, :date
  end
end
