class AddUniqueIndexToJobApplications < ActiveRecord::Migration[6.1]
  def change
    add_index :job_applications, [:user_id, :job_offer_id], unique: true
  end
end
