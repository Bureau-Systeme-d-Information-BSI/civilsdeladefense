class AddEstimateMonthlySalaryNetToSalaryRanges < ActiveRecord::Migration[5.2]
  def change
    add_column :salary_ranges, :estimate_monthly_salary_net, :string
  end
end
