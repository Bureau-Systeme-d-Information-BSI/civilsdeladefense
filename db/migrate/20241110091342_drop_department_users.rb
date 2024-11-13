class DropDepartmentUsers < ActiveRecord::Migration[7.1]
  def up
    drop_table :department_users
  end

  def down
    create_table :department_users, id: :uuid do |t|
      t.references :department, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
