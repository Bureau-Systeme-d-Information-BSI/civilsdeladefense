require "rails_helper"

RSpec.describe ForeignLanguageLevel do
  describe "associations" do
    it { is_expected.to have_many(:profile_foreign_languages).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end

# == Schema Information
#
# Table name: foreign_language_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_foreign_language_levels_on_name      (name) UNIQUE
#  index_foreign_language_levels_on_position  (position)
#
