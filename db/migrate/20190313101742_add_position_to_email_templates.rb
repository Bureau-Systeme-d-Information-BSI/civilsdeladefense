# frozen_string_literal: true

class AddPositionToEmailTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :email_templates, :position, :integer
    EmailTemplate.order(:updated_at).each.with_index(1) do |item, index|
      item.update_column :position, index
    end
    add_index :email_templates, :position
  end
end
