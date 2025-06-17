class CreateAdministratorEmployers < ActiveRecord::Migration[7.1]
  def change
    create_table :administrator_employers, id: :uuid do |t|
      t.references :administrator, null: false, foreign_key: true, type: :uuid
      t.references :employer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
