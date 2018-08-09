class CreateJobOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :job_offers do |t|
      t.references :owner, foreign_key: {to_table: :admins}
      t.string :title
      t.text :description
      t.references :category, foreign_key: true
      t.references :official_status, foreign_key: true
      t.string :location
      t.references :employer, foreign_key: true
      t.text :required_profile
      t.text :recruitment_process
      t.references :contract_type, foreign_key: true
      t.date :contract_start_on
      t.boolean :is_remote_possible
      t.references :study_level, foreign_key: true
      t.references :experience_level, foreign_key: true
      t.references :sector, foreign_key: true
      t.boolean :is_negotiable
      t.string :estimate_monthly_salary_net
      t.string :estimate_monthly_salary_gross
      t.integer :option_cover_letter
      t.integer :option_resume
      t.integer :option_portfolio
      t.integer :option_photo
      t.integer :option_website_url
      t.integer :option_linkedin_url

      t.timestamps
    end
  end
end
