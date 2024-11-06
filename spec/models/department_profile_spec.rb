require "rails_helper"

RSpec.describe DepartmentProfile do
  describe "associations" do
    it { is_expected.to belong_to(:department) }

    it { is_expected.to belong_to(:profile) }
  end
end

# == Schema Information
#
# Table name: department_profiles
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :uuid             not null
#  profile_id    :uuid             not null
#
# Indexes
#
#  index_department_profiles_on_department_id  (department_id)
#  index_department_profiles_on_profile_id     (profile_id)
#
# Foreign Keys
#
#  fk_rails_4fcacb9e58  (department_id => departments.id)
#  fk_rails_ded23d970e  (profile_id => profiles.id)
#
