# frozen_string_literal: true

# Preferred candidates for a recruiter, attached to a list with a name
class PreferredUser < ApplicationRecord
  belongs_to :user
  belongs_to :preferred_users_list, counter_cache: true

  validates :user_id, uniqueness: {scope: :preferred_users_list_id}
end

# == Schema Information
#
# Table name: preferred_users
#
#  id                      :uuid             not null, primary key
#  note                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  preferred_users_list_id :uuid
#  user_id                 :uuid
#
# Indexes
#
#  index_preferred_users_on_preferred_users_list_id              (preferred_users_list_id)
#  index_preferred_users_on_user_id                              (user_id)
#  index_preferred_users_on_user_id_and_preferred_users_list_id  (user_id,preferred_users_list_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_366304c2c9  (preferred_users_list_id => preferred_users_lists.id)
#  fk_rails_aef4e3b0a7  (user_id => users.id)
#
