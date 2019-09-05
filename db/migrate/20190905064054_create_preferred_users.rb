# frozen_string_literal: true

class CreatePreferredUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :preferred_users, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.references :preferred_users_list, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
