# frozen_string_literal: true

class RemoveOptionFielsFromJobOffers < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_offers, :option_cover_letter
    remove_column :job_offers, :option_resume
    remove_column :job_offers, :option_website_url
  end
end
