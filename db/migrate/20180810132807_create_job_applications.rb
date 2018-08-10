class CreateJobApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :job_applications do |t|
      t.references :job_offer, foreign_key: true
      t.references :user, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :current_position
      t.string :phone
      t.string :address_1
      t.string :address_2
      t.string :postal_code
      t.string :city
      t.string :country
      t.string :portfolio_url
      t.string :website_url
      t.string :linkedin_url

      t.timestamps
    end
  end
end
