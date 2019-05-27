# frozen_string_literal: true

class RemoveIsNegotiableFromJobOffers < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_offers, :is_negotiable, :boolean
  end
end
