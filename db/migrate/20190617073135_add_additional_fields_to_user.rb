# frozen_string_literal: true

class AddAdditionalFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :integer, limit: 2
    add_column :users, :birth_date, :date
    add_column :users, :nationality, :string, limit: 2
    add_column :users, :has_residence_permit, :boolean
    add_column :users, :is_currently_employed, :boolean
    add_column :users, :availability_date_in_month, :integer
    add_reference :users, :study_level, type: :uuid, foreign_key: true
    add_column :users, :study_type, :string
    add_column :users, :specialization, :string
    add_reference :users, :experience_level, type: :uuid, foreign_key: true
    add_column :users, :corporate_experience, :boolean
    add_column :job_applications, :skills_fit_job_offer, :boolean
    add_column :job_applications, :experiences_fit_job_offer, :boolean
  end
end
