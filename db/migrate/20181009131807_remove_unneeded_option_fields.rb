class RemoveUnneededOptionFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_offers, :option_portfolio_url, :integer
    remove_column :job_offers, :option_linkedin_url, :integer
    remove_column :job_applications, :portfolio_url, :string
    remove_column :job_applications, :linkedin_url, :string
    remove_column :users, :linkedin_url, :string
  end
end
