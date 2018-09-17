class EmailTemplate < ApplicationRecord
  validates :title, :subject, :body, presence: true
end
