class ChangeDarDefaultsToFalseOnJobApplications < ActiveRecord::Migration[7.1]
  def change
    change_column_default :job_applications, :dar, from: nil, to: false
  end
end
