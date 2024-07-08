class RenameBneToMobiliaInJobOffers < ActiveRecord::Migration[7.1]
  def change
    rename_column :job_offers, :bne_value, :mobilia_value
    rename_column :job_offers, :bne_date, :mobilia_date
  end
end
