class RemoveDurationContractFromJobOffers < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :job_offers, :duration_contract, :string }
  end
end
