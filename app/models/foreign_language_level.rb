class ForeignLanguageLevel < ApplicationRecord
  has_many :profile_foreign_languages, dependent: :destroy
end

# == Schema Information
#
# Table name: foreign_language_levels
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
