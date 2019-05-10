# frozen_string_literal: true

# Email template selectable to prefill real email to be sent by recruiter
class EmailTemplate < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :title, :subject, :body, presence: true
end
