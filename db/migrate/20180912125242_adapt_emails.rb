# frozen_string_literal: true

class AdaptEmails < ActiveRecord::Migration[5.2]
  def change
    rename_column :emails, :title, :subject

    add_reference :emails, :sender, type: :uuid, polymorphic: true, index: true

    Email.all.each do |email|
      administrator = Administrator.find email.administrator_id
      email.sender = administrator
      email.save!
    end

    remove_column :emails, :administrator_id
  end
end
