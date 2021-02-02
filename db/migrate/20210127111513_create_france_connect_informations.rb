# frozen_string_literal: true

class CreateFranceConnectInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :france_connect_informations, id: :uuid do |t|
      t.string :sub, null: false
      t.string :email, null: false
      t.string :family_name
      t.string :given_name
      t.references :user, type: :uuid

      t.timestamps
    end

    add_index :france_connect_informations, :sub, unique: true
  end
end
