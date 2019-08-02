# frozen_string_literal: true

class CompletePersonalProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :personal_profiles, :current_position, :string

    JobApplication.order(created_at: :asc).each do |job_application|
      params = {
        current_position: job_application.current_position,
        phone: job_application.phone,
        address_1: job_application.address_1,
        address_2: job_application.address_2,
        postcode: job_application.postal_code,
        city: job_application.city,
        country: job_application.country,
        website_url: job_application.website_url
      }
      job_application.create_personal_profile!(params)
      job_application.user.create_personal_profile!(params)
    end

    remove_column :job_applications, :first_name, :string
    remove_column :job_applications, :last_name, :string
    remove_column :job_applications, :current_position, :string
    remove_column :job_applications, :phone, :string
    remove_column :job_applications, :address_1, :string
    remove_column :job_applications, :address_2, :string
    remove_column :job_applications, :postal_code, :string
    remove_column :job_applications, :city, :string
    remove_column :job_applications, :country, :string
    remove_column :job_applications, :website_url, :string

    remove_column :users, :current_position, :string
    remove_column :users, :phone, :string
    remove_column :users, :address_1, :string
    remove_column :users, :address_2, :string
    remove_column :users, :postal_code, :string
    remove_column :users, :city, :string
    remove_column :users, :country, :string
    remove_column :users, :website_url, :string
  end
end
