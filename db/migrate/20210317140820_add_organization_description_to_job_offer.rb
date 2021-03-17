class AddOrganizationDescriptionToJobOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :job_offers, :organization_description, :text
  end
end
