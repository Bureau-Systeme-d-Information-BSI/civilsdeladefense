class ModifyChildrenCountColumn < ActiveRecord::Migration[5.2]
  def change
    change_column_null :categories, :children_count, false
    change_column_null :employers, :children_count, false
  end
end
