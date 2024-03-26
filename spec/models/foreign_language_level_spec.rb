require "rails_helper"

RSpec.describe ForeignLanguageLevel do
  describe "associations" do
    it { is_expected.to have_many(:profile_foreign_languages).dependent(:destroy) }
  end
end
