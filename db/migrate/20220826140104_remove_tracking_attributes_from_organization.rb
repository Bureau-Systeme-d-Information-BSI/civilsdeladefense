class RemoveTrackingAttributesFromOrganization < ActiveRecord::Migration[7.0]
  def change
    remove_column :organizations, :matomo_site_id, :string
    remove_column :organizations, :atinternet_site_id, :string
  end
end
