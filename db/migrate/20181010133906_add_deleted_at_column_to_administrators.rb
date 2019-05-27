# frozen_string_literal: true

class AddDeletedAtColumnToAdministrators < ActiveRecord::Migration[5.2]
  def change
    add_column :administrators, :deleted_at, :datetime
  end
end
