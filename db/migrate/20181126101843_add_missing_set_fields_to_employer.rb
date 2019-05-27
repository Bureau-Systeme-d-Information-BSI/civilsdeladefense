# frozen_string_literal: true

class AddMissingSetFieldsToEmployer < ActiveRecord::Migration[5.2]
  def change
    add_column :employers, :parent_id, :uuid, index: true
    add_column :employers, :lft, :integer, index: true
    add_column :employers, :rgt, :integer, index: true
    add_column :employers, :depth, :integer, default: 0
    add_column :employers, :children_count, :integer, default: 0

    # This is necessary to update :lft and :rgt columns
    Employer.reset_column_information
    Employer.rebuild!
  end
end
