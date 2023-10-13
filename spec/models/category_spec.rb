# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category do
  it { is_expected.to validate_presence_of(:name) }
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
