class AddHelpFileToOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :help_file, :string
  end
end
