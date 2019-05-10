# frozen_string_literal: true

class AddAvailableImmediatelyToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :available_immediately, :boolean, default: false
  end
end
