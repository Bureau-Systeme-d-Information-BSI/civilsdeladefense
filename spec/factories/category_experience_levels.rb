FactoryBot.define do
  factory :category_experience_level do
    category
    experience_level
    profile
  end
end

# == Schema Information
#
# Table name: category_experience_levels
#
#  id                  :uuid             not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  category_id         :uuid             not null
#  experience_level_id :uuid             not null
#  profile_id          :uuid             not null
#
# Indexes
#
#  index_category_experience_levels_on_category_id          (category_id)
#  index_category_experience_levels_on_experience_level_id  (experience_level_id)
#  index_category_experience_levels_on_profile_id           (profile_id)
#
# Foreign Keys
#
#  fk_rails_56b0e96a85  (profile_id => profiles.id)
#  fk_rails_8b2267bf51  (experience_level_id => experience_levels.id)
#  fk_rails_bc1fef62a6  (category_id => categories.id)
#
