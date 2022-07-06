# frozen_string_literal: true

class ArchivingReason < ApplicationRecord
  acts_as_list

  has_many :job_offers, dependent: :nullify, inverse_of: :archiving_reason

  default_scope -> { order(position: :asc) }

  validates :name, presence: true
end

# == Schema Information
#
# Table name: archiving_reasons
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_archiving_reasons_on_position  (position)
#
