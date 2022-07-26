# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::SalaryRanges", type: :request do
  it_behaves_like "an admin setting", :salary_range, :estimate_monthly_salary_net, "10 000 €", {
    professional_category_id: ProfessionalCategory.first.id,
    experience_level_id: ExperienceLevel.first.id,
    sector_id: Sector.first.id
  }
end
