# frozen_string_literal: true

class Admin::SalaryRangesController < Admin::BaseController
  def index
    professional_category_id = params.dig(:job_offer, :professional_category_id)
    experience_level_id = params.dig(:job_offer, :experience_level_id)
    sector_id = params.dig(:job_offer, :sector_id)
    if professional_category_id.present? && experience_level_id.present? && sector_id.present?
      @salary_ranges = SalaryRange.by_main_factors(professional_category_id,
                                                   experience_level_id,
                                                   sector_id)
    else
      @salary_ranges = []
    end

    render json: @salary_ranges.to_json
  end
end
