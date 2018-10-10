class RenameMonthlyToAnnualy < ActiveRecord::Migration[5.2]
  def change
    rename_column :job_offers, :estimate_monthly_salary_gross, :estimate_annual_salary_gross
  end
end
