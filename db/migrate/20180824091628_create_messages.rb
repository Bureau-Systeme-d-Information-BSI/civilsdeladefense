class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :job_application, foreign_key: true
      t.references :administrator, foreign_key: true

      t.timestamps
    end
  end
end
