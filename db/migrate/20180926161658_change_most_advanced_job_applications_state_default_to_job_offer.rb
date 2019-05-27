# frozen_string_literal: true

class ChangeMostAdvancedJobApplicationsStateDefaultToJobOffer < ActiveRecord::Migration[5.2]
  def change
    change_column_default :job_offers, :most_advanced_job_applications_state, from: 0, to: -1
  end
end
