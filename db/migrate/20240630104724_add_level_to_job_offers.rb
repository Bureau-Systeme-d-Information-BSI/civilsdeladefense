class AddLevelToJobOffers < ActiveRecord::Migration[7.1]
  def change
    add_reference :job_offers, :level, null: true, foreign_key: true, type: :uuid
  end
end
