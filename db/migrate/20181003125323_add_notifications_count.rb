# frozen_string_literal: true

class AddNotificationsCount < ActiveRecord::Migration[5.2]
  def change
    add_column :job_applications, :files_count, :integer, default: 0
    add_column :job_applications, :files_unread_count, :integer, default: 0
    add_column :job_applications, :emails_count, :integer, default: 0
    add_column :job_applications, :emails_administrator_unread_count, :integer, default: 0
    add_column :job_applications, :emails_user_unread_count, :integer, default: 0
    add_column :job_applications, :administrator_notifications_count, :integer, default: 0
    add_column :emails, :is_unread, :boolean, default: true
    add_column :job_offers, :notifications_count, :integer, default: 0
    Email.all.update_all is_unread: true
    Email.counter_culture_fix_counts skip_unsupported: true
    Email.all.map(&:save)
  end
end
