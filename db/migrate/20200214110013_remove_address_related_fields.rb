# frozen_string_literal: true

class RemoveAddressRelatedFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :personal_profiles, :address_1
    remove_column :personal_profiles, :address_2
    remove_column :personal_profiles, :postcode
    remove_column :personal_profiles, :city
    remove_column :personal_profiles, :country
  end
end
