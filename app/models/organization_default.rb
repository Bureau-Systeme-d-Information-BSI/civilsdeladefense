# frozen_string_literal: true

# Default values when creating a new job offer (for example)
class OrganizationDefault < ApplicationRecord
  #####################################
  # Relationships

  belongs_to :organization

  #####################################
  # Validations

  validates :value, :kind, presence: true
  validates :kind, uniqueness: { scope: :organization_id }

  #####################################
  # Enums
  enum kind: {
    job_offer_description: 10,
    job_offer_recruitment_process: 20
  }
end
