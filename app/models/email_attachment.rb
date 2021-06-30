class EmailAttachment < ApplicationRecord
  belongs_to :email

  mount_uploader :content, AttachmentUploader
end

# == Schema Information
#
# Table name: email_attachments
#
#  id         :uuid             not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email_id   :uuid             not null
#
# Indexes
#
#  index_email_attachments_on_email_id  (email_id)
#
# Foreign Keys
#
#  fk_rails_fd120c16f6  (email_id => emails.id)
#
