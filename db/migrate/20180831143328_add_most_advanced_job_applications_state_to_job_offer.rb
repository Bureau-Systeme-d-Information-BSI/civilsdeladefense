class AddMostAdvancedJobApplicationsStateToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :most_advanced_job_applications_state, :integer, default: 0
  end
end
