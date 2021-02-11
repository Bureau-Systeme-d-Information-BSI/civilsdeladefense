# frozen_string_literal: true

class AddSuspensionFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :suspension_reason, :string
    add_column :users, :suspended_at, :datetime
  end
end
