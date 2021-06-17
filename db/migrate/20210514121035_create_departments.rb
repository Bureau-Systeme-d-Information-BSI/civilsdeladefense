class CreateDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :departments, id: :uuid do |t|
      t.string :name
      t.string :name_region
      t.string :code_region
      t.string :code

      t.timestamps
    end

    create_table :department_users, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :department, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
