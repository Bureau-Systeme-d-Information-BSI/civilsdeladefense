class EmailTemplate < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :title, :subject, :body, presence: true
end
