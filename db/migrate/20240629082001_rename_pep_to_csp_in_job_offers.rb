class RenamePepToCspInJobOffers < ActiveRecord::Migration[7.1]
  def change
    rename_column :job_offers, :pep_value, :csp_value
    rename_column :job_offers, :pep_date, :csp_date
  end
end
