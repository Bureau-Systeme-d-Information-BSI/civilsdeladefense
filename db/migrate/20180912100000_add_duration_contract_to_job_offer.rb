class AddDurationContractToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :duration_contract, :string
  end
end