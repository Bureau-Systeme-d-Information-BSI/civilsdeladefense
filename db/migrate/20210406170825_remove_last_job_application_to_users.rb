class RemoveLastJobApplicationToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :last_job_application, {
      type: :uuid, foreign_key: {to_table: :job_applications}
    }
  end
end
