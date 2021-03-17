# frozen_string_literal: true

# Internal messaging system exchanged by recruiters around a specific job application
class Message < ApplicationRecord
  belongs_to :job_application
  belongs_to :administrator

  validates :body, presence: true

  default_scope { order(created_at: :desc) }

  audited associated_with: :job_application
end

# == Schema Information
#
# Table name: messages
#
#  id                 :uuid             not null, primary key
#  body               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  administrator_id   :uuid
#  job_application_id :uuid
#
# Indexes
#
#  index_messages_on_administrator_id    (administrator_id)
#  index_messages_on_job_application_id  (job_application_id)
#
# Foreign Keys
#
#  fk_rails_4d089d0d3c  (administrator_id => administrators.id)
#  fk_rails_eadecc2ae1  (job_application_id => job_applications.id)
#
