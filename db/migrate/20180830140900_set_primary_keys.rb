class SetPrimaryKeys < ActiveRecord::Migration[5.2]
  def change
    tables = ActiveRecord::Base.connection.tables.map(&:to_sym)
    tables.delete(:schema_migrations)
    tables.delete(:ar_internal_metadata)
    tables.delete(:active_storage_attachments)
    tables.delete(:active_storage_blobs)
    tables.delete(:friendly_id_slugs)

    tables.each do |table|
      remove_column table, :id
      rename_column table, :uuid_temp, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end
  end
end
