# frozen_string_literal: true

require "rails_helper"

RSpec.describe SalaryRange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
