class AddReceiveJobOfferMailsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :receive_job_offer_mails, :boolean, default: false
  end
end
