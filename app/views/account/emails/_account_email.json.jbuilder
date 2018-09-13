json.extract! account_email, :id, :subject, :body, :created_at, :updated_at
json.url account_email_url(account_email, format: :json)
