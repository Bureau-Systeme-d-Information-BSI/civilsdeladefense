class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :recipient, null: false, foreign_key: {to_table: :administrators}, type: :uuid
      t.references :instigator, foreign_key: {to_table: :administrators}, type: :uuid
      t.references :job_offer, foreign_key: true, type: :uuid
      t.references :job_application, foreign_key: true, type: :uuid
      t.boolean :daily, default: false
      t.string :kind

      t.timestamps
    end
  end
end
