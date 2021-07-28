class UserMenuLink < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }
  validates :name, :url, presence: true
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
