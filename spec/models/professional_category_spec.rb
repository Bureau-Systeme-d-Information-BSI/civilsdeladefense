# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfessionalCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: professional_categories
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_professional_categories_on_name      (name) UNIQUE
#  index_professional_categories_on_position  (position)
#
