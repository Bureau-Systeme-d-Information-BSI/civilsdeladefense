# frozen_string_literal: true

class CreateOmniauthInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :omniauth_informations, id: :uuid do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.references :user, type: :uuid

      t.timestamps
    end

    add_index :omniauth_informations, %i[uid provider], unique: true
  end
end
