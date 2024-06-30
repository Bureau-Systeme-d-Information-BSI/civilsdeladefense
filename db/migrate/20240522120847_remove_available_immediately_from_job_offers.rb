class RemoveAvailableImmediatelyFromJobOffers < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_offers, :available_immediately, :boolean
  end
end
