# frozen_string_literal: true

class AddAddresFieldsToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :city, :string
    add_column :job_offers, :county, :string
    add_column :job_offers, :county_code, :integer
    add_column :job_offers, :country_code, :string
    add_column :job_offers, :postcode, :string
    add_column :job_offers, :region, :string
  end
end
