# frozen_string_literal: true

class AddHoursDelayBeforePublishingToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :hours_delay_before_publishing, :integer, default: nil
  end
end
