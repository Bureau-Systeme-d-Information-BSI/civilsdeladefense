class RemoveFilenameFromZipFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :zip_files, :filename, :string
  end
end
