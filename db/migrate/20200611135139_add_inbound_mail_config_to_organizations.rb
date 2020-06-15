# frozen_string_literal: true

class AddInboundMailConfigToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :inbound_email_config, :integer, default: 0
  end
end
