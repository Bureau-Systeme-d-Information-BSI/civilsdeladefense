# frozen_string_literal: true

class AddPublishedAtToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :published_at, :datetime

    JobOffer.where(state: :published, published_at: nil).all.each(&:rebuild_published_timestamp!)
  end
end
