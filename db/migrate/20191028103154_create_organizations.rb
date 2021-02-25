# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.string :business_owner_name
      t.string :administrator_email_suffix
      t.string :subdomain
      t.string :domain
      %w[logo_vertical logo_horizontal
        logo_vertical_negative logo_horizontal_negative
        image_background].each do |file|
        t.string "#{file}_file_name"
        t.string "#{file}_content_type"
        t.bigint "#{file}_file_size"
        t.datetime "#{file}_updated_at"
      end

      t.timestamps
    end
  end
end
