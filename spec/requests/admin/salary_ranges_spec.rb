# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::SalaryRanges" do
  before { sign_in create(:administrator) }

  describe "GET /admin/salary_ranges" do
    context "when the factors are provided" do
      it "returns the salary ranges" do
        salary_range = create(:salary_range)

        get admin_salary_ranges_path, params: {
          job_offer: {
            sector_id: salary_range.sector_id,
            professional_category_id: salary_range.professional_category_id,
            experience_level_id: salary_range.experience_level_id
          }
        }
        expect(response.body).to eq([salary_range].to_json)
      end
    end

    context "when no factor is provided" do
      it "returns an empty list" do
        get admin_salary_ranges_path
        expect(response.body).to eq([].to_json)
      end
    end
  end
end
