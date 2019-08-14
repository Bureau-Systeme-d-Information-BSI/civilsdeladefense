# frozen_string_literal: true

class AddArchivedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :archived_at, :datetime

    JobOffer.where(state: :archived, archived_at: nil).all.each(&:rebuild_archived_timestamp!)
  end
end
