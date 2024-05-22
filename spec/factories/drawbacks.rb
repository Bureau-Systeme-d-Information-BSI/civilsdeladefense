FactoryBot.define do
  factory :drawback do
    name { Faker::Name.unique.name }
  end
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
