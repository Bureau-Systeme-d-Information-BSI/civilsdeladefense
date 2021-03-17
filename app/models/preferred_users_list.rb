# frozen_string_literal: true

# List of preferred candidates for a recruiter
class PreferredUsersList < ApplicationRecord
  belongs_to :administrator
  has_many :preferred_users, dependent: :destroy
  has_many :users, through: :preferred_users

  validates :name, presence: true
end

# == Schema Information
#
# Table name: preferred_users_lists
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  note                  :text
#  preferred_users_count :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  administrator_id      :uuid
#
# Indexes
#
#  index_preferred_users_lists_on_administrator_id  (administrator_id)
#
# Foreign Keys
#
#  fk_rails_528934fe4f  (administrator_id => administrators.id)
#
