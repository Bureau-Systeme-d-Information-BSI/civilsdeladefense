class AddArchivingReasonToJobOffers < ActiveRecord::Migration[6.1]
  def change
    add_reference :job_offers, :archiving_reason, null: true, foreign_key: true, type: :uuid
  end
end
