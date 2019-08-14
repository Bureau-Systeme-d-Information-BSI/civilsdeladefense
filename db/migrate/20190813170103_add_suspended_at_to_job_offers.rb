# frozen_string_literal: true

class AddSuspendedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :suspended_at, :datetime

    JobOffer.where(state: :suspended, suspended_at: nil).all.each(&:rebuild_suspended_timestamp!)
  end
end
