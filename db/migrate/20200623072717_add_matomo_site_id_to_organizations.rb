# frozen_string_literal: true

class AddMatomoSiteIdToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :matomo_site_id, :string
  end
end
