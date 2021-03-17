# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { "MyString" }
    body { "MyText" }
    og_title { "MyString" }
    og_description { "MyString" }
    organization { nil }
  end
end

# == Schema Information
#
# Table name: pages
#
#  id              :uuid             not null, primary key
#  body            :text
#  children_count  :integer          default(0), not null
#  depth           :integer
#  lft             :integer          not null
#  og_description  :string
#  og_title        :string
#  only_link       :boolean          default(FALSE), not null
#  rgt             :integer          not null
#  slug            :string
#  title           :string
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  parent_id       :uuid
#
# Indexes
#
#  index_pages_on_lft              (lft)
#  index_pages_on_organization_id  (organization_id)
#  index_pages_on_parent_id        (parent_id)
#  index_pages_on_rgt              (rgt)
#
# Foreign Keys
#
#  fk_rails_8ecbce3eb4  (organization_id => organizations.id)
#
