# frozen_string_literal: true

# User personal information like gender, birthdate, etc.
class UserProfile < ApplicationRecord
  belongs_to :user_profileable, polymorphic: true
  belongs_to :study_level, optional: true
  belongs_to :experience_level, optional: true
  belongs_to :availability_range, optional: true
  belongs_to :age_range, optional: true

  #####################################
  # Validations

  validates :current_position,
            :phone,
            presence: true

  #####################################
  # Enums
  enum gender: {
    female: 1,
    male: 2,
    other: 3
  }

  def datalake_attributes
    attributes.except('id',
                      'user_profileable_type',
                      'user_profileable_id',
                      'created_at',
                      'updated_at')
  end

  def datalake_to_job_application_profiles!(options = {})
    relation = user_profileable.job_applications_active

    if (except = options.delete(:except))
      relation = relation.where.not('job_applications.id = ?', except)
    end

    relation.each do |job_application|
      if job_application.user_profile.nil?
        job_application.create_user_profile(datalake_attributes)
      else
        job_application.user_profile.update(datalake_attributes)
      end
    end
  end

  def datalake_to_user_profile!
    user = user_profileable.user
    if user.user_profile.nil?
      user.create_user_profile(datalake_attributes)
    else
      user.user_profile.update(datalake_attributes)
    end
  end
end
