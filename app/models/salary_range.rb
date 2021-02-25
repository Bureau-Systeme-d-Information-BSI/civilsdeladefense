# frozen_string_literal: true

# Salary amount depending on external main factors. Will build a salary grid.
class SalaryRange < ApplicationRecord
  belongs_to :professional_category
  belongs_to :experience_level
  belongs_to :sector

  validates :estimate_annual_salary_gross, :estimate_monthly_salary_net, presence: true

  scope :admin_settings_index_includes, lambda {
    includes(:professional_category, :sector, :experience_level)
  }
  scope :admin_settings_index_order, lambda {
    order("professional_categories.name asc, sectors.name asc, experience_levels.name asc")
  }
  scope :admin_settings_index, -> { admin_settings_index_includes.admin_settings_index_order }
  scope :by_main_factors, lambda { |professional_category_id, experience_level_id, sector_id|
    where(professional_category_id: professional_category_id,
          experience_level_id: experience_level_id,
          sector_id: sector_id)
  }
end
