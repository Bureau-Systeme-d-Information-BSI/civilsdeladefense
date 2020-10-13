# frozen_string_literal: true

# User information without PII
class Profile < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  belongs_to :study_level, optional: true
  belongs_to :experience_level, optional: true
  belongs_to :availability_range, optional: true
  belongs_to :age_range, optional: true

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
