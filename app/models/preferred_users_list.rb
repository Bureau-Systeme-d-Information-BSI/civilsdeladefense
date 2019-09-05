# frozen_string_literal: true

# List of preferred candidates for a recruiter
class PreferredUsersList < ApplicationRecord
  belongs_to :administrator
  has_many :preferred_users, dependent: :destroy
  has_many :users, through: :preferred_users

  validates :name, presence: true
end
