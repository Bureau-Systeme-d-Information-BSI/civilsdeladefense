class AddIdentifierToJobOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :identifier, :string
    add_index :job_offers, :identifier, unique: true
  end
end
