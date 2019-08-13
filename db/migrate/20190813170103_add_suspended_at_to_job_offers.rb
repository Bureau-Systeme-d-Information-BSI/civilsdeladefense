# frozen_string_literal: true

class AddSuspendedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :suspended_at, :datetime

    JobOffer.where(state: :suspended).all.each do |job_offer|
      target_audit = job_offer.audits.reorder(version: :desc).detect do |audit|
        audit.audited_changes.keys.include?('state') && audit.audited_changes['state'] == 'suspended'
      end
      job_offer.update_column :suspended_at, target_audit.created_at if target_audit
    end
  end
end
