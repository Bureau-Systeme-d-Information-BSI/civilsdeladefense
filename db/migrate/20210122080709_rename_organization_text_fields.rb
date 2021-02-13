# frozen_string_literal: true

class RenameOrganizationTextFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :name, :service_name
    add_column :organizations, :service_description, :string
    add_column :organizations, :service_description_short, :string
    rename_column :organizations, :name_business_owner, :brand_name
    add_column :organizations, :prefix_article, :string
    add_column :organizations, :linkedin_url, :string
    add_column :organizations, :twitter_url, :string
    add_column :organizations, :youtube_url, :string
    add_column :organizations, :instagram_url, :string
    add_column :organizations, :facebook_url, :string
    %w[operator partner_1 partner_2 partner_3].each do |field|
      add_column :organizations, "#{field}_name", :string
      add_column :organizations, "#{field}_url", :string
      add_column :organizations, "#{field}_logo_file_name", :string
      add_column :organizations, "#{field}_logo_content_type", :string
      add_column :organizations, "#{field}_logo_file_size", :bigint
      add_column :organizations, "#{field}_logo_updated_at", :datetime
    end
  end
end
