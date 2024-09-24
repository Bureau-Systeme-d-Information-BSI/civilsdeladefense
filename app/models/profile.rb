# frozen_string_literal: true

# User information without PII
class Profile < ApplicationRecord
  belongs_to :profileable, polymorphic: true

  # Deprecated on 2024-08-23: will be removed after v1.5.0
  # TODO: SEB remove this line after v1.5.0
  belongs_to :job_application,
    -> { where(profiles: {profileable_type: "JobApplication"}) },
    foreign_key: "profileable_id",
    optional: true,
    inverse_of: :profile
  belongs_to :study_level, optional: true
  belongs_to :experience_level, optional: true
  belongs_to :availability_range, optional: true
  belongs_to :age_range, optional: true

  has_many :profile_foreign_languages, dependent: :destroy
  has_many :category_experience_levels, dependent: :destroy

  accepts_nested_attributes_for :profile_foreign_languages,
    reject_if: proc { |attrs| attrs["foreign_language_id"].blank? || attrs["foreign_language_level_id"].blank? }
  accepts_nested_attributes_for :category_experience_levels,
    reject_if: proc { |attrs| attrs["category_id"].blank? || attrs["experience_level_id"].blank? }

  validate :at_least_one_category_experience_level, on: :profile

  def at_least_one_category_experience_level
    return if category_experience_levels.any?

    errors.add(:base, :at_least_one_category_experience_level)
  end

  #####################################
  # Validations

  #####################################
  # Enums
  enum gender: {
    female: 1,
    male: 2,
    other: 3
  }
end

# == Schema Information
#
# Table name: profiles
#
#  id                       :uuid             not null, primary key
#  gender                   :integer
#  has_corporate_experience :boolean
#  is_currently_employed    :boolean
#  profileable_type         :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  age_range_id             :uuid
#  availability_range_id    :uuid
#  experience_level_id      :uuid
#  profileable_id           :uuid
#  study_level_id           :uuid
#
# Indexes
#
#  index_personal_profileable_type_and_id   (profileable_type,profileable_id)
#  index_profiles_on_age_range_id           (age_range_id)
#  index_profiles_on_availability_range_id  (availability_range_id)
#  index_profiles_on_experience_level_id    (experience_level_id)
#  index_profiles_on_study_level_id         (study_level_id)
#
# Foreign Keys
#
#  fk_rails_75f0622ea4  (availability_range_id => availability_ranges.id)
#  fk_rails_a4e341a6cb  (study_level_id => study_levels.id)
#  fk_rails_a9c80e4a8d  (experience_level_id => experience_levels.id)
#  fk_rails_b71acccf4c  (age_range_id => age_ranges.id)
#
