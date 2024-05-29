class Drawback < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: drawbacks
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_drawbacks_on_name      (name) UNIQUE
#  index_drawbacks_on_position  (position)
#
