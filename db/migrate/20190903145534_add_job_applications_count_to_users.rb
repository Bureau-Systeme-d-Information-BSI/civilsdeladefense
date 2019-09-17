# frozen_string_literal: true

class AddJobApplicationsCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :job_applications_count, :integer, null: false, default: 0

    JobApplication.counter_culture_fix_counts only: :user
  end
end
