# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::SalaryRanges" do
  let(:create_attributes) {
    {
      professional_category_id: professional_categories(:cadre).id,
      experience_level_id: experience_levels(:beginner).id,
      sector_id: sectors(:technique).id
    }
  }

  it_behaves_like "an admin setting", :salary_range, :estimate_monthly_salary_net, "10 000 €"
end
