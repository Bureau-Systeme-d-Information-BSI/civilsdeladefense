class CreateJobApplicationFileTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :job_application_file_types, id: :uuid do |t|
      t.string :name
      t.string :description
      t.integer :kind
      t.string :content_file_name
      t.string :from_state
      t.boolean :by_default, default: false
      t.integer :position

      t.timestamps
    end
  end
end
