class RemoveAvailableImmediatelyFromJobOffers < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :job_offers, :available_immediately, :boolean }
  end
end
