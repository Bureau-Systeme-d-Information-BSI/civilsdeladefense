# frozen_string_literal: true

class AddJobApplicationsCountToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :job_applications_count, :integer, null: false, default: 0
    JobApplication.aasm.states.each do |state|
      state_name = state.name.to_s
      add_column :job_offers,
                 "#{state_name}_job_applications_count",
                 :integer,
                 null: false,
                 default: 0
    end
    JobApplication.counter_culture_fix_counts
  end
end
