class AddApplicationDeadlineToJobOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :job_offers, :application_deadline, :date
  end
end
