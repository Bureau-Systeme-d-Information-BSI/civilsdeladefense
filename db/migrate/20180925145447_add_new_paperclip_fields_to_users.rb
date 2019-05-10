# frozen_string_literal: true

class AddNewPaperclipFieldsToUsers < ActiveRecord::Migration[5.2]
  def up
    add_attachment :users, :transport_ticket
    add_column :users, :transport_ticket_is_validated, :smallint, default: 0
  end

  def down
    remove_attachment :users, :transport_ticket
    remove_column :users, :transport_ticket_is_validated
  end
end
