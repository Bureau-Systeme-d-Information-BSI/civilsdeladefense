class SetForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key "emails", "administrators"
    add_foreign_key "emails", "job_applications"
    add_foreign_key "job_applications", "job_offers"
    add_foreign_key "job_applications", "users"
    add_foreign_key "job_offers", "administrators", column: "owner_id"
    add_foreign_key "job_offers", "categories"
    add_foreign_key "job_offers", "contract_types"
    add_foreign_key "job_offers", "employers"
    add_foreign_key "job_offers", "experience_levels"
    add_foreign_key "job_offers", "official_statuses"
    add_foreign_key "job_offers", "sectors"
    add_foreign_key "job_offers", "study_levels"
    add_foreign_key "messages", "administrators"
    add_foreign_key "messages", "job_applications"
  end
end
