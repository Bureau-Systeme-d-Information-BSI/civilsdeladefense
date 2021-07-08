class CreateBenefitJobOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :benefit_job_offers, id: :uuid do |t|
      t.references :benefit, null: false, foreign_key: true, type: :uuid
      t.references :job_offer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
