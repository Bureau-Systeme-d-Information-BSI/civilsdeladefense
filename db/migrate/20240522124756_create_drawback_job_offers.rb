class CreateDrawbackJobOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :drawback_job_offers, id: :uuid do |t|
      t.references :drawback, null: false, foreign_key: true, type: :uuid
      t.references :job_offer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
