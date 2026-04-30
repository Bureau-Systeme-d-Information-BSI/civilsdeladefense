class AddIcttctAscPositionnbCoverLetterToJobOffer < ActiveRecord::Migration[7.1]
  def change
    change_table :job_offers, bulk: true do |t|
      t.boolean :ict_tct, null: false, default: false
      t.boolean :asc, null: false, default: false
      t.boolean :cov_letter_required, null: false, default: :false
      t.integer :position_nb, null: false, default: 1
    end
  end
end
