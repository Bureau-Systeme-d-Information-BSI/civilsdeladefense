# frozen_string_literal: true

class AddArchivedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :archived_at, :datetime

    JobOffer.where(state: :archived).all.each do |job_offer|
      target_audit = job_offer.audits.reorder(version: :desc).detect do |audit|
        audit.audited_changes.keys.include?('state') && audit.audited_changes['state'] == 'archived'
      end
      job_offer.update_column :archived_at, target_audit.created_at if target_audit
    end
  end
end
