class AddEmployerIdToJobApplication < ActiveRecord::Migration[5.2]
  def change
    add_reference :job_applications, :employer, type: :uuid, foreign_key: true

    JobApplication.all.map{|x|
      x.update_column :employer_id, x.job_offer.employer_id
    }
  end
end
