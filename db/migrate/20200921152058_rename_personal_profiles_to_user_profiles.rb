# frozen_string_literal: true

class RenamePersonalProfilesToUserProfiles < ActiveRecord::Migration[6.0]
  def change
    rename_table :personal_profiles, :user_profiles

    rename_column :user_profiles, :personal_profileable_type, :user_profileable_type
    rename_column :user_profiles, :personal_profileable_id, :user_profileable_id
  end
end
