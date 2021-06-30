class AddAtinternetSiteIdToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :atinternet_site_id, :string
  end
end
