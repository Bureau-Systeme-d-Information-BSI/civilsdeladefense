# frozen_string_literal: true

class RenamePersonalProfilesToProfiles < ActiveRecord::Migration[6.0]
  def change
    rename_table :personal_profiles, :profiles

    rename_column :profiles, :personal_profileable_type, :profileable_type
    rename_column :profiles, :personal_profileable_id, :profileable_id
  end
end
