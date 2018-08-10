json.extract! admin_job_application, :id, :job_offer_id, :user_id, :first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :portfolio_url, :website_url, :linkedin_url, :created_at, :updated_at
json.url admin_job_application_url(admin_job_application, format: :json)
