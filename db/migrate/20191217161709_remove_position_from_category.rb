# frozen_string_literal: true

class RemovePositionFromCategory < ActiveRecord::Migration[6.0]
  def change
    remove_column :categories, :position, :integer, index: true
  end
end
