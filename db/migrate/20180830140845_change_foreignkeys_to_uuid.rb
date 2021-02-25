# frozen_string_literal: true

class FriendlyIdSlug < ApplicationRecord; end

class ActiveStorageAttachment < ApplicationRecord; end

class ChangeForeignkeysToUuid < ActiveRecord::Migration[5.2]
  def up
    simple_id_to_uuid "emails", "administrators"
    simple_id_to_uuid "emails", "job_applications"
    simple_id_to_uuid "job_applications", "job_offers"
    simple_id_to_uuid "job_applications", "users"
    simple_id_to_uuid "job_offers", "administrators", column: "owner_id"
    simple_id_to_uuid "job_offers", "categories"
    simple_id_to_uuid "job_offers", "contract_types"
    simple_id_to_uuid "job_offers", "employers"
    simple_id_to_uuid "job_offers", "experience_levels"
    simple_id_to_uuid "job_offers", "official_statuses"
    simple_id_to_uuid "job_offers", "sectors"
    simple_id_to_uuid "job_offers", "study_levels"
    simple_id_to_uuid "messages", "administrators"
    simple_id_to_uuid "messages", "job_applications"

    polymorphic_id_to_uuid "active_storage_attachments", "record"
    polymorphic_id_to_uuid "friendly_id_slugs", "sluggable"
  end

  def simple_id_to_uuid(from_table, to_table, options = {})
    column_name = options[:column].gsub("_id", "") if options[:column].present?
    column_name ||= to_table.singularize
    foreign_key = "#{column_name}_id".to_sym
    new_foreign_key = "#{column_name}_uuid".to_sym

    add_column from_table, new_foreign_key, :uuid

    from_klass = from_table.classify.constantize
    to_klass = to_table.classify.constantize

    from_klass.where.not(foreign_key => nil).each do |record|
      associated_record = to_klass.find_by(id: record.send(foreign_key))
      record.update_column(new_foreign_key, associated_record.uuid_temp) if associated_record
    end

    remove_column from_table, foreign_key
    rename_column from_table, new_foreign_key, foreign_key
    add_index from_table, foreign_key
  end

  def polymorphic_id_to_uuid(from_table, column_name)
    foreign_key = "#{column_name}_id".to_sym
    foreign_key_type = "#{column_name}_type".to_sym
    new_foreign_key = "#{column_name}_uuid".to_sym

    add_column from_table, new_foreign_key, :uuid

    from_klass = from_table.classify.constantize

    from_klass.all.each do |record|
      to_klass = record.send(foreign_key_type).classify.constantize
      associated_record = to_klass.find_by(id: record.send(foreign_key))
      record.update_column(new_foreign_key, associated_record.uuid_temp) if associated_record
    end

    remove_column from_table, foreign_key
    rename_column from_table, new_foreign_key, foreign_key
    case from_table
    when "active_storage_attachments"
      add_index from_table,
        %w[record_type record_id name blob_id],
        name: "index_active_storage_attachments_uniqueness",
        unique: true
    when "friendly_id_slugs"
      add_index from_table, foreign_key
    end
  end
end
