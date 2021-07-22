class AddPepAndBneToJobOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :job_offers, :pep_value, :string
    add_column :job_offers, :pep_date, :date
    add_column :job_offers, :bne_value, :string
    add_column :job_offers, :bne_date, :date
  end
end
