class CreateUserMenuLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_menu_links, id: :uuid do |t|
      t.string :name
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
