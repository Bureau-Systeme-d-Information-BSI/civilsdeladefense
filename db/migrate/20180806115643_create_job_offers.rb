# frozen_string_literal: true

class CreateJobOffers < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Metrics/BlockLength
    create_table :job_offers do |t|
      t.references :owner, foreign_key: {to_table: :administrators}
      t.string :title
      t.string :slug, null: false
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
    # rubocop:enable Metrics/BlockLength

    add_index :job_offers, :slug, unique: true
  end
end
