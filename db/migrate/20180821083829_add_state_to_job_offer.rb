class AddStateToJobOffer < ActiveRecord::Migration[5.2]
  def change
    add_column :job_offers, :state, :integer

    JobOffer.update_all state: 0

    add_index :job_offers, :state
  end
end
