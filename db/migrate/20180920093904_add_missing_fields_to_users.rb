# frozen_string_literal: true

class AddMissingFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_position, :string
    add_column :users, :phone, :string
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :postal_code, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :website_url, :string
    add_column :users, :linkedin_url, :string
  end
end
