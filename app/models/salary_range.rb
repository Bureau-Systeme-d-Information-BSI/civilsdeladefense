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

# == Schema Information
#
# Table name: salary_ranges
#
#  id                           :uuid             not null, primary key
#  estimate_annual_salary_gross :string
#  estimate_monthly_salary_net  :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  experience_level_id          :uuid
#  professional_category_id     :uuid
#  sector_id                    :uuid
#
# Indexes
#
#  index_salary_ranges_on_experience_level_id       (experience_level_id)
#  index_salary_ranges_on_professional_category_id  (professional_category_id)
#  index_salary_ranges_on_sector_id                 (sector_id)
#
# Foreign Keys
#
#  fk_rails_01f39ec8ac  (professional_category_id => professional_categories.id)
#  fk_rails_212f7ced5a  (experience_level_id => experience_levels.id)
#  fk_rails_b239f2741c  (sector_id => sectors.id)
#
