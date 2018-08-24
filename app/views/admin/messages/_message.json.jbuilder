json.extract! message, :id, :body, :job_application_id, :administrator_id, :created_at, :updated_at
json.url admin_message_url(message, format: :json)
