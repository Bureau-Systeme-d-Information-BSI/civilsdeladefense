# frozen_string_literal: true

json.extract! admin_settings_category, :id, :name, :position, :created_at, :updated_at
json.url admin_settings_category_url(admin_settings_category, format: :json)
