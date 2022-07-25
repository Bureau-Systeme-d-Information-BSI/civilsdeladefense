class CreateArchivingReasons < ActiveRecord::Migration[6.1]
  def change
    create_table :archiving_reasons, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_index :archiving_reasons, :position
  end
end
