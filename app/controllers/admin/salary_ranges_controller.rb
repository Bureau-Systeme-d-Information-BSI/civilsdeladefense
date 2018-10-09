class Admin::SalaryRangesController < Admin::BaseController

  def index
    if params[:job_offer][:professional_category_id].present? &&
      params[:job_offer][:experience_level_id].present? &&
      params[:job_offer][:sector_id].present?
      @salary_ranges = SalaryRange.all
      @salary_ranges = @salary_ranges.where(professional_category_id: params[:job_offer][:professional_category_id])
      @salary_ranges = @salary_ranges.where(experience_level_id: params[:job_offer][:experience_level_id])
      @salary_ranges = @salary_ranges.where(sector_id: params[:job_offer][:sector_id])
    else
      @salary_ranges = []
    end

    render json: @salary_ranges.to_json
  end
end
