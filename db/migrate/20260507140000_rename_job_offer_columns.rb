# frozen_string_literal: true

class RenameJobOfferColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :job_offers, :cov_letter_required, :cover_lettre_required if column_exists?(:job_offers, :cov_letter_required)
    rename_column :job_offers, :position_nb, :positions_count if column_exists?(:job_offers, :position_nb)
  end
end
