class ForeignLanguage < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  has_many :profile_foreign_languages, dependent: :nullify
end

# == Schema Information
#
# Table name: foreign_languages
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
