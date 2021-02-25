# frozen_string_literal: true

class RemovePhoneMeetingAcceptedJobApplicationsCountFromJobOffers < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_offers,
      :phone_meeting_accepted_job_applications_count,
      :integer,
      default: 0,
      null: false
    JobApplication.where(state: 4).update_all(state: 5)
  end
end
