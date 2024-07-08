require "rails_helper"
RSpec.describe Level do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "scopes" do
    it "default_scope orders by position" do
      expect(described_class.all.to_sql).to include("ORDER BY \"levels\".\"position\" ASC")
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:job_offers).dependent(:nullify) }
  end
end

# == Schema Information
#
# Table name: levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_levels_on_name      (name) UNIQUE
#  index_levels_on_position  (position)
#
