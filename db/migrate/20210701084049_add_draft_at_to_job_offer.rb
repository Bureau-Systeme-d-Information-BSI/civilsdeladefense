class AddDraftAtToJobOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :job_offers, :draft_at, :datetime
  end
end
