# frozen_string_literal: true

FactoryBot.define do
  factory :organization_default do
    value { "a value" }
    kind { :job_offer_description }
    organization { Organization.last }
  end
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
#  index_organization_defaults_on_kind                      (kind)
#  index_organization_defaults_on_kind_and_organization_id  (kind,organization_id) UNIQUE
#  index_organization_defaults_on_organization_id           (organization_id)
#
# Foreign Keys
#
#  fk_rails_0f3d6bc988  (organization_id => organizations.id)
#
