# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_28_104158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_administrators_on_unlock_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "contract_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_contract_types_on_name", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "job_application_id"
    t.bigint "administrator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrator_id"], name: "index_emails_on_administrator_id"
    t.index ["job_application_id"], name: "index_emails_on_job_application_id"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_employers_on_name", unique: true
  end

  create_table "experience_levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_experience_levels_on_name", unique: true
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "job_offer_id"
    t.bigint "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "current_position"
    t.string "phone"
    t.string "address_1"
    t.string "address_2"
    t.string "postal_code"
    t.string "city"
    t.string "country"
    t.string "portfolio_url"
    t.string "website_url"
    t.string "linkedin_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.index ["job_offer_id"], name: "index_job_applications_on_job_offer_id"
    t.index ["state"], name: "index_job_applications_on_state"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_offers", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "title"
    t.string "slug", null: false
    t.text "description"
    t.bigint "category_id"
    t.bigint "official_status_id"
    t.string "location"
    t.bigint "employer_id"
    t.text "required_profile"
    t.text "recruitment_process"
    t.bigint "contract_type_id"
    t.date "contract_start_on"
    t.boolean "is_remote_possible"
    t.bigint "study_level_id"
    t.bigint "experience_level_id"
    t.bigint "sector_id"
    t.boolean "is_negotiable"
    t.string "estimate_monthly_salary_net"
    t.string "estimate_monthly_salary_gross"
    t.integer "option_cover_letter"
    t.integer "option_resume"
    t.integer "option_portfolio_url"
    t.integer "option_photo"
    t.integer "option_website_url"
    t.integer "option_linkedin_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.integer "job_applications_count", default: 0, null: false
    t.integer "initial_job_applications_count", default: 0, null: false
    t.integer "rejected_job_applications_count", default: 0, null: false
    t.integer "phone_meeting_job_applications_count", default: 0, null: false
    t.integer "phone_meeting_rejected_job_applications_count", default: 0, null: false
    t.integer "phone_meeting_accepted_job_applications_count", default: 0, null: false
    t.integer "to_be_met_job_applications_count", default: 0, null: false
    t.integer "after_meeting_rejected_job_applications_count", default: 0, null: false
    t.integer "accepted_job_applications_count", default: 0, null: false
    t.integer "contract_drafting_job_applications_count", default: 0, null: false
    t.integer "contract_feedback_waiting_job_applications_count", default: 0, null: false
    t.integer "contract_received_job_applications_count", default: 0, null: false
    t.integer "affected_job_applications_count", default: 0, null: false
    t.index ["category_id"], name: "index_job_offers_on_category_id"
    t.index ["contract_type_id"], name: "index_job_offers_on_contract_type_id"
    t.index ["employer_id"], name: "index_job_offers_on_employer_id"
    t.index ["experience_level_id"], name: "index_job_offers_on_experience_level_id"
    t.index ["official_status_id"], name: "index_job_offers_on_official_status_id"
    t.index ["owner_id"], name: "index_job_offers_on_owner_id"
    t.index ["sector_id"], name: "index_job_offers_on_sector_id"
    t.index ["slug"], name: "index_job_offers_on_slug", unique: true
    t.index ["state"], name: "index_job_offers_on_state"
    t.index ["study_level_id"], name: "index_job_offers_on_study_level_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "job_application_id"
    t.bigint "administrator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrator_id"], name: "index_messages_on_administrator_id"
    t.index ["job_application_id"], name: "index_messages_on_job_application_id"
  end

  create_table "official_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_official_statuses_on_name", unique: true
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sectors_on_name", unique: true
  end

  create_table "study_levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_study_levels_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

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
