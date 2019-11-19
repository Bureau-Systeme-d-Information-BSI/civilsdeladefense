# frozen_string_literal: true

class AddOrganizationIdToJobOffer < ActiveRecord::Migration[6.0]
  def change
    add_reference(:job_offers, :organization, type: :uuid)
    add_reference(:job_applications, :organization, type: :uuid)
  end
end
