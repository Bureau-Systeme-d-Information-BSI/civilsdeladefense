FactoryBot.define do
  factory :user_menu_link do
    name { "MyString" }
    url { "MyString" }
  end
end

# == Schema Information
#
# Table name: user_menu_links
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
