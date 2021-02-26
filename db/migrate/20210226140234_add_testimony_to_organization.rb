class AddTestimonyToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, "testimony_title", :string
    add_column :organizations, "testimony_subtitle", :string
    add_column :organizations, "testimony_url", :string
    add_column :organizations, "testimony_logo_file_name", :string
    add_column :organizations, "testimony_logo_content_type", :string
    add_column :organizations, "testimony_logo_file_size", :bigint
    add_column :organizations, "testimony_logo_updated_at", :datetime
  end
end
