class AddCodeToEmployers < ActiveRecord::Migration[5.2]
  def change
    add_column :employers, :code, :string
  end
end
