# frozen_string_literal: true

class AddLastJobApplicationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :last_job_application, {
      type: :uuid, foreign_key: { to_table: :job_applications }
    }
    User.all.each do |user|
      id = user.job_applications.first.id
      user.update_column(:last_job_application_id, id) if last_job_application
    end
  end
end
