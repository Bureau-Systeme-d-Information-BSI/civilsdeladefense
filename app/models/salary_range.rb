class SalaryRange < ApplicationRecord
  belongs_to :professional_category
  belongs_to :experience_level
  belongs_to :sector

  validates :estimate_annual_salary_gross, :estimate_monthly_salary_net, presence: true
end
