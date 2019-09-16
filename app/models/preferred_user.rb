# frozen_string_literal: true

# Preferred candidates for a recruiter, attached to a list with a name
class PreferredUser < ApplicationRecord
  belongs_to :user
  belongs_to :preferred_users_list

  counter_culture :preferred_users_list,
                  column_name: 'preferred_users_count',
                  touch: true

  validates :user_id, uniqueness: { scope: :preferred_users_list_id }
end
