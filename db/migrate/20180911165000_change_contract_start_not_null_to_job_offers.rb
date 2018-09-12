class ChangeContractStartNotNullToJobOffers < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:job_offers, :contract_start_on, false)
  end
end