# frozen_string_literal: true

class RationalizePii < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :website_url, :string
    add_column :users, :phone, :string
    add_column :users, :current_position, :string

    profiles = Profile.where.not(website_url: nil)
                      .where.not(phone: nil)
                      .where.not(current_position: nil)
    profiles.each do |profile|
      obj = profile.profileable
      hsh = {
        website_url: profile.website_url,
        phone: profile.phone,
        current_position: profile.current_position
      }
      if obj.is_a?(User)
        obj.update_columns(hsh)
        putc '.'
      elsif obj.is_a?(JobApplication)
        obj.user.update_columns(hsh)
        putc '.'
      end
    end

    remove_column :profiles, :website_url, :string
    remove_column :profiles, :phone, :string
    remove_column :profiles, :current_position, :string
  end
end
