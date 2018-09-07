class AddSequentialIdToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :sequential_id, :integer
  end
end
