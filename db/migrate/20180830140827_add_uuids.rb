class AddUuids < ActiveRecord::Migration[5.2]
  def change
    tables = ActiveRecord::Base.connection.tables.map(&:to_sym)
    tables.delete(:schema_migrations)
    tables.delete(:ar_internal_metadata)
    tables.delete(:active_storage_attachments)
    tables.delete(:active_storage_blobs)
    tables.delete(:friendly_id_slugs)

    tables.each do |table|
      add_column table, :uuid_temp, :uuid, default: 'gen_random_uuid()', null: false
    end
  end
end
