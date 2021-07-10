class FrequentlyAskedQuestion < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, :value, presence: true
end

# == Schema Information
#
# Table name: frequently_asked_questions
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
