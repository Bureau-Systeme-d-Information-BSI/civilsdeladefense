# frozen_string_literal: true

require "rails_helper"

RSpec.describe Employer do
  describe "associations" do
    it { is_expected.to have_many(:job_offers).dependent(:nullify) }

    it { is_expected.to have_many(:administrator_employers).dependent(:destroy) }

    it { is_expected.to have_many(:administrators).through(:administrator_employers) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end

# == Schema Information
#
# Table name: employers
#
#  id             :uuid             not null, primary key
#  children_count :integer          default(0), not null
#  code           :string
#  depth          :integer          default(0)
#  lft            :integer
#  name           :string
#  rgt            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :uuid
#
# Indexes
#
#  index_employers_on_name  (name) UNIQUE
#
