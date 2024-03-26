class ForeignLanguageLevel < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

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
# Indexes
#
#  index_foreign_language_levels_on_name      (name) UNIQUE
#  index_foreign_language_levels_on_position  (position)
#
