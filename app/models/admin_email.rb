class AdminEmail < ApplicationRecord
  serialize :data
end

# == Schema Information
#
# Table name: admin_emails
#
#  id           :uuid             not null, primary key
#  data         :text
#  email        :string
#  service_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_admin_emails_on_email  (email)
#
