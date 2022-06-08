class CreateZipFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :zip_files, id: :uuid do |t|
      t.string :filename

      t.timestamps
    end
  end
end
