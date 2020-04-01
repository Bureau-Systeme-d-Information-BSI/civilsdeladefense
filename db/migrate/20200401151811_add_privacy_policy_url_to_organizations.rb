# frozen_string_literal: true

class AddPrivacyPolicyUrlToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :privacy_policy_url, :string
  end
end
