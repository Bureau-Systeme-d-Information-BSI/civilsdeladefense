class CreateJobOfferTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :job_offer_terms, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_column :organizations, :job_offer_term_title, :string
    add_column :organizations, :job_offer_term_subtitle, :string
    add_column :organizations, :job_offer_term_warning, :string
  end
end
