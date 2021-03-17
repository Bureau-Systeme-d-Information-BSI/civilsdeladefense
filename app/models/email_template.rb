# frozen_string_literal: true

# Email template selectable to prefill real email to be sent by recruiter
class EmailTemplate < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :title, :subject, :body, presence: true
end

# == Schema Information
#
# Table name: email_templates
#
#  id         :uuid             not null, primary key
#  body       :text
#  position   :integer
#  subject    :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_email_templates_on_position  (position)
#
