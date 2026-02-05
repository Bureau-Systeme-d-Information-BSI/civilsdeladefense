class AddIdTokenToOmniauthInformations < ActiveRecord::Migration[7.2]
  def change
    add_column :omniauth_informations, :id_token, :text
  end
end
