# frozen_string_literal: true

# Default values when creating a new job offer (for example)
class OrganizationDefault < ApplicationRecord
  #####################################
  # Relationships

  belongs_to :organization

  #####################################
  # Validations

  validates :value, :kind, presence: true
  validates :kind, uniqueness: {scope: :organization_id}

  #####################################
  # Enums
  enum kind: {
    job_offer_description: 10,
    job_offer_recruitment_process: 20,
    job_offer_organization_description: 30
  }
end

# == Schema Information
#
# Table name: organization_defaults
#
#  id              :uuid             not null, primary key
#  kind            :integer
#  value           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_organization_defaults_on_kind             (kind)
#  index_organization_defaults_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_0f3d6bc988  (organization_id => organizations.id)
#
