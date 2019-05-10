# frozen_string_literal: true

class ActsAsListToProfessionalCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :professional_categories, :position, :integer
    ProfessionalCategory.order(:updated_at).each.with_index(1) do |item, index|
      item.update_column :position, index
    end
  end
end
