FactoryBot.define do
  factory :profile_foreign_language do
    profile { nil }
    foreign_language { nil }
    foreign_language_level { nil }
  end
end

# == Schema Information
#
# Table name: profile_foreign_languages
#
#  id                        :uuid             not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  foreign_language_id       :uuid             not null
#  foreign_language_level_id :uuid             not null
#  profile_id                :uuid             not null
#
# Indexes
#
#  index_profile_foreign_languages_on_foreign_language_id        (foreign_language_id)
#  index_profile_foreign_languages_on_foreign_language_level_id  (foreign_language_level_id)
#  index_profile_foreign_languages_on_profile_id                 (profile_id)
#
# Foreign Keys
#
#  fk_rails_095620779d  (foreign_language_level_id => foreign_language_levels.id)
#  fk_rails_11de83256d  (profile_id => profiles.id)
#  fk_rails_80bb7be19e  (foreign_language_id => foreign_languages.id)
#
