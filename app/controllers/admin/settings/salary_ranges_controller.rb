class Admin::Settings::SalaryRangesController < Admin::Settings::InheritedResourcesController

  protected

    def permitted_fields
      %i(professional_category_id experience_level_id sector_id estimate_annual_salary_gross)
    end
end
