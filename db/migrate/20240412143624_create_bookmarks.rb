class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks, id: :uuid do |t|
      t.references :job_offer, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :bookmarks, %i[job_offer_id user_id], unique: true
  end
end
