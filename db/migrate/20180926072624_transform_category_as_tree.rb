class TransformCategoryAsTree < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :parent_id, :uuid, index: true
    add_column :categories, :lft, :integer, index: true
    add_column :categories, :rgt, :integer, index: true
    add_column :categories, :depth, :integer, default: 0
    add_column :categories, :children_count, :integer, default: 0

    # This is necessary to update :lft and :rgt columns
    Category.reset_column_information
    Category.rebuild!
  end
end
