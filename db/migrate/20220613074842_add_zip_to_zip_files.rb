class AddZipToZipFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :zip_files, :zip, :string
  end
end
