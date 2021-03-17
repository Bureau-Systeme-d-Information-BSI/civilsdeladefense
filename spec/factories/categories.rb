# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Commerce.unique.department }
  end
end

# == Schema Information
#
# Table name: categories
#
#  id                         :uuid             not null, primary key
#  children_count             :integer          default(0), not null
#  depth                      :integer          default(0)
#  lft                        :integer
#  name                       :string
#  published_job_offers_count :integer          default(0), not null
#  rgt                        :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  parent_id                  :uuid
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
