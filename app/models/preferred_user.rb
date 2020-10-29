# frozen_string_literal: true

# Preferred candidates for a recruiter, attached to a list with a name
class PreferredUser < ApplicationRecord
  belongs_to :user
  belongs_to :preferred_users_list, counter_cache: true

  validates :user_id, uniqueness: { scope: :preferred_users_list_id }
end
