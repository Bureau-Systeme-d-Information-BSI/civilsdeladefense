# frozen_string_literal: true

# Reasons when rejecting a job application. Manageable by admins.
class RejectionReason < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true
end

# == Schema Information
#
# Table name: rejection_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rejection_reasons_on_position  (position)
#
