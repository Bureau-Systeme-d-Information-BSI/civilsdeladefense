# frozen_string_literal: true

class CreateJobOfferActors < ActiveRecord::Migration[5.2]
  def change
    create_table :job_offer_actors, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :job_offer, type: :uuid, foreign_key: true
      t.references :administrator, type: :uuid, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
