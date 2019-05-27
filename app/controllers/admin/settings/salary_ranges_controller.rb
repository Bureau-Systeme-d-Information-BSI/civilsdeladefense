# frozen_string_literal: true

class Admin::Settings::SalaryRangesController < Admin::Settings::InheritedResourcesController
  def index
    @professional_categories = ProfessionalCategory.all
    @sectors = Sector.all
    @experience_levels = ExperienceLevel.all
    @q = SalaryRange.ransack(params[:q])
    @salary_ranges = @q.result.admin_settings_index
  end

  def update
    key = "admin.settings.#{resource_class.to_s.tableize}.update.success"
    update!(notice: t(key)) do |success, _failure|
      success.json { render json: resource.to_json }
    end
  end

  protected

  def permitted_fields
    %i[professional_category_id experience_level_id sector_id
       estimate_annual_salary_gross estimate_monthly_salary_net]
  end
end
