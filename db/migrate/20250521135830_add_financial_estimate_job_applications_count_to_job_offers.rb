class AddFinancialEstimateJobApplicationsCountToJobOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :job_offers, :financial_estimate_job_applications_count, :integer, default: 0, null: false
  end
end
