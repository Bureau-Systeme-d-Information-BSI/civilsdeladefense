# frozen_string_literal: true

class CreatePreferredUsersLists < ActiveRecord::Migration[5.2]
  def change
    create_table :preferred_users_lists, id: :uuid do |t|
      t.string :name
      t.references :administrator, foreign_key: true, type: :uuid
      t.integer :preferred_users_count, null: false, default: 0

      t.timestamps
    end
  end
end
