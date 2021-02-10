# frozen_string_literal: true

class RenameOrganizationTextFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :name, :service_name
    add_column :organizations, :service_description, :string
    add_column :organizations, :service_description_short, :string
    rename_column :organizations, :name_business_owner, :brand_name
    add_column :organizations, :brand_prefix_article, :string
    add_column :organizations, :operator_name, :string
    %w[operator_logo].each do |file|
      add_column :organizations, "#{file}_file_name", :string
      add_column :organizations, "#{file}_content_type", :string
      add_column :organizations, "#{file}_file_size", :bigint
      add_column :organizations, "#{file}_updated_at", :datetime
    end
  end
end
