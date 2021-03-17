# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreferredUsersList, type: :model do
  it { should validate_presence_of(:name) }
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
