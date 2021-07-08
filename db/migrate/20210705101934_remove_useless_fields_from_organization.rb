class RemoveUselessFieldsFromOrganization < ActiveRecord::Migration[6.1]
  def change
    remove_column :organizations, :domain, :string
    remove_column :organizations, :logo_horizontal_negative_content_type, :string
    remove_column :organizations, :logo_horizontal_negative_file_name, :string
    remove_column :organizations, :logo_horizontal_negative_file_size, :bigint
    remove_column :organizations, :logo_horizontal_negative_updated_at, :datetime
    remove_column :organizations, :logo_vertical_content_type, :string
    remove_column :organizations, :logo_vertical_file_name, :string
    remove_column :organizations, :logo_vertical_file_size, :bigint
    remove_column :organizations, :logo_vertical_negative_content_type, :string
    remove_column :organizations, :logo_vertical_negative_file_name, :string
    remove_column :organizations, :logo_vertical_negative_file_size, :bigint
    remove_column :organizations, :logo_vertical_negative_updated_at, :datetime
    remove_column :organizations, :logo_vertical_updated_at, :datetime
    remove_column :organizations, :subdomain, :string
  end
end
