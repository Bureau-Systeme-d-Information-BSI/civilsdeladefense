# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_04_064340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.uuid "record_id"
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

  create_table "administrators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "first_name"
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
    t.string "title"
    t.uuid "employer_id"
    t.integer "role"
    t.string "last_name"
    t.uuid "inviter_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean "very_first_account", default: false
    t.datetime "deleted_at"
    t.uuid "supervisor_administrator_id"
    t.uuid "grand_employer_administrator_id"
    t.index ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["employer_id"], name: "index_administrators_on_employer_id"
    t.index ["grand_employer_administrator_id"], name: "index_administrators_on_grand_employer_administrator_id"
    t.index ["inviter_id"], name: "index_administrators_on_inviter_id"
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["supervisor_administrator_id"], name: "index_administrators_on_supervisor_administrator_id"
    t.index ["unlock_token"], name: "index_administrators_on_unlock_token", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.uuid "auditable_id"
    t.string "auditable_type"
    t.uuid "associated_id"
    t.string "associated_type"
    t.uuid "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bops", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_bops_on_position"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.uuid "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth", default: 0
    t.integer "children_count", default: 0, null: false
    t.integer "published_job_offers_count", default: 0, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "contract_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_contract_types_on_name", unique: true
    t.index ["position"], name: "index_contract_types_on_position"
  end

  create_table "email_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["position"], name: "index_email_templates_on_position"
  end

  create_table "emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_application_id"
    t.string "sender_type"
    t.uuid "sender_id"
    t.boolean "is_unread", default: true
    t.index ["job_application_id"], name: "index_emails_on_job_application_id"
    t.index ["sender_type", "sender_id"], name: "index_emails_on_sender_type_and_sender_id"
  end

  create_table "employers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.uuid "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth", default: 0
    t.integer "children_count", default: 0, null: false
    t.index ["name"], name: "index_employers_on_name", unique: true
  end

  create_table "experience_levels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_experience_levels_on_name", unique: true
    t.index ["position"], name: "index_experience_levels_on_position"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.uuid "sluggable_id"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "job_application_file_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "kind"
    t.string "content_file_name"
    t.string "old_from_state"
    t.boolean "by_default", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_state"
  end

  create_table "job_application_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "content_file_name"
    t.integer "is_validated", limit: 2, default: 0
    t.uuid "job_application_id"
    t.uuid "job_application_file_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_application_file_type_id"], name: "index_job_application_files_on_job_application_file_type_id"
    t.index ["job_application_id"], name: "index_job_application_files_on_job_application_id"
  end

  create_table "job_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.uuid "job_offer_id"
    t.uuid "user_id"
    t.uuid "employer_id"
    t.integer "old_cover_letter_is_validated", limit: 2, default: 0
    t.integer "old_resume_is_validated", limit: 2, default: 0
    t.integer "old_photo_is_validated", limit: 2, default: 0
    t.string "old_cover_letter_file_name"
    t.string "old_cover_letter_content_type"
    t.bigint "old_cover_letter_file_size"
    t.datetime "old_cover_letter_updated_at"
    t.string "old_resume_file_name"
    t.string "old_resume_content_type"
    t.bigint "old_resume_file_size"
    t.datetime "old_resume_updated_at"
    t.string "old_photo_file_name"
    t.string "old_photo_content_type"
    t.bigint "old_photo_file_size"
    t.datetime "old_photo_updated_at"
    t.integer "emails_unread_count", default: 0
    t.integer "files_count", default: 0
    t.integer "files_unread_count", default: 0
    t.integer "emails_count", default: 0
    t.integer "emails_administrator_unread_count", default: 0
    t.integer "emails_user_unread_count", default: 0
    t.integer "administrator_notifications_count", default: 0
    t.boolean "skills_fit_job_offer"
    t.boolean "experiences_fit_job_offer"
    t.uuid "rejection_reason_id"
    t.index ["employer_id"], name: "index_job_applications_on_employer_id"
    t.index ["job_offer_id"], name: "index_job_applications_on_job_offer_id"
    t.index ["rejection_reason_id"], name: "index_job_applications_on_rejection_reason_id"
    t.index ["state"], name: "index_job_applications_on_state"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_offer_actors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_offer_id"
    t.uuid "administrator_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrator_id"], name: "index_job_offer_actors_on_administrator_id"
    t.index ["job_offer_id"], name: "index_job_offer_actors_on_job_offer_id"
  end

  create_table "job_offers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "slug", null: false
    t.text "description"
    t.string "location"
    t.text "required_profile"
    t.text "recruitment_process"
    t.date "contract_start_on", null: false
    t.boolean "is_remote_possible"
    t.string "estimate_monthly_salary_net"
    t.string "estimate_annual_salary_gross"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.integer "job_applications_count", default: 0, null: false
    t.integer "initial_job_applications_count", default: 0, null: false
    t.integer "rejected_job_applications_count", default: 0, null: false
    t.integer "phone_meeting_job_applications_count", default: 0, null: false
    t.integer "phone_meeting_rejected_job_applications_count", default: 0, null: false
    t.integer "to_be_met_job_applications_count", default: 0, null: false
    t.integer "after_meeting_rejected_job_applications_count", default: 0, null: false
    t.integer "accepted_job_applications_count", default: 0, null: false
    t.integer "contract_drafting_job_applications_count", default: 0, null: false
    t.integer "contract_feedback_waiting_job_applications_count", default: 0, null: false
    t.integer "contract_received_job_applications_count", default: 0, null: false
    t.integer "affected_job_applications_count", default: 0, null: false
    t.uuid "owner_id"
    t.uuid "category_id"
    t.uuid "contract_type_id"
    t.uuid "employer_id"
    t.uuid "experience_level_id"
    t.uuid "professional_category_id"
    t.uuid "sector_id"
    t.uuid "study_level_id"
    t.integer "most_advanced_job_applications_state", default: -1
    t.integer "sequential_id"
    t.string "identifier"
    t.string "duration_contract"
    t.integer "option_photo"
    t.integer "notifications_count", default: 0
    t.boolean "available_immediately", default: false
    t.string "city"
    t.string "county"
    t.integer "county_code"
    t.string "country_code"
    t.string "postcode"
    t.string "region"
    t.datetime "published_at"
    t.datetime "archived_at"
    t.datetime "suspended_at"
    t.uuid "bop_id"
    t.index ["bop_id"], name: "index_job_offers_on_bop_id"
    t.index ["category_id"], name: "index_job_offers_on_category_id"
    t.index ["contract_type_id"], name: "index_job_offers_on_contract_type_id"
    t.index ["employer_id"], name: "index_job_offers_on_employer_id"
    t.index ["experience_level_id"], name: "index_job_offers_on_experience_level_id"
    t.index ["identifier"], name: "index_job_offers_on_identifier", unique: true
    t.index ["owner_id"], name: "index_job_offers_on_owner_id"
    t.index ["professional_category_id"], name: "index_job_offers_on_professional_category_id"
    t.index ["sector_id"], name: "index_job_offers_on_sector_id"
    t.index ["slug"], name: "index_job_offers_on_slug", unique: true
    t.index ["state"], name: "index_job_offers_on_state"
    t.index ["study_level_id"], name: "index_job_offers_on_study_level_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "administrator_id"
    t.uuid "job_application_id"
    t.index ["administrator_id"], name: "index_messages_on_administrator_id"
    t.index ["job_application_id"], name: "index_messages_on_job_application_id"
  end

  create_table "official_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_official_statuses_on_name", unique: true
  end

  create_table "personal_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "personal_profileable_type"
    t.uuid "personal_profileable_id"
    t.integer "gender"
    t.date "birth_date"
    t.string "nationality"
    t.string "website_url"
    t.string "address_1"
    t.string "address_2"
    t.string "postcode"
    t.string "city"
    t.string "country"
    t.string "phone"
    t.boolean "has_residence_permit"
    t.boolean "is_currently_employed"
    t.integer "availability_date_in_month"
    t.uuid "study_level_id"
    t.string "study_type"
    t.string "specialization"
    t.uuid "experience_level_id"
    t.boolean "has_corporate_experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_position"
    t.index ["experience_level_id"], name: "index_personal_profiles_on_experience_level_id"
    t.index ["personal_profileable_type", "personal_profileable_id"], name: "index_personal_profileable_type_and_id"
    t.index ["study_level_id"], name: "index_personal_profiles_on_study_level_id"
  end

  create_table "preferred_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "preferred_users_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["preferred_users_list_id"], name: "index_preferred_users_on_preferred_users_list_id"
    t.index ["user_id"], name: "index_preferred_users_on_user_id"
  end

  create_table "preferred_users_lists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "administrator_id"
    t.integer "preferred_users_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["administrator_id"], name: "index_preferred_users_lists_on_administrator_id"
  end

  create_table "professional_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_professional_categories_on_name", unique: true
    t.index ["position"], name: "index_professional_categories_on_position"
  end

  create_table "rejection_reasons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["position"], name: "index_rejection_reasons_on_position"
  end

  create_table "salary_ranges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "estimate_annual_salary_gross"
    t.uuid "professional_category_id"
    t.uuid "experience_level_id"
    t.uuid "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estimate_monthly_salary_net"
    t.index ["experience_level_id"], name: "index_salary_ranges_on_experience_level_id"
    t.index ["professional_category_id"], name: "index_salary_ranges_on_professional_category_id"
    t.index ["sector_id"], name: "index_salary_ranges_on_sector_id"
  end

  create_table "sectors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_sectors_on_name", unique: true
    t.index ["position"], name: "index_sectors_on_position"
  end

  create_table "study_levels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_study_levels_on_name", unique: true
    t.index ["position"], name: "index_study_levels_on_position"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "old_resume_file_name"
    t.string "old_resume_content_type"
    t.bigint "old_resume_file_size"
    t.datetime "old_resume_updated_at"
    t.string "old_cover_letter_file_name"
    t.string "old_cover_letter_content_type"
    t.bigint "old_cover_letter_file_size"
    t.datetime "old_cover_letter_updated_at"
    t.string "old_diploma_file_name"
    t.string "old_diploma_content_type"
    t.bigint "old_diploma_file_size"
    t.datetime "old_diploma_updated_at"
    t.string "old_identity_file_name"
    t.string "old_identity_content_type"
    t.bigint "old_identity_file_size"
    t.datetime "old_identity_updated_at"
    t.string "old_carte_vitale_certificate_file_name"
    t.string "old_carte_vitale_certificate_content_type"
    t.bigint "old_carte_vitale_certificate_file_size"
    t.datetime "old_carte_vitale_certificate_updated_at"
    t.string "old_proof_of_address_file_name"
    t.string "old_proof_of_address_content_type"
    t.bigint "old_proof_of_address_file_size"
    t.datetime "old_proof_of_address_updated_at"
    t.string "old_medical_certificate_file_name"
    t.string "old_medical_certificate_content_type"
    t.bigint "old_medical_certificate_file_size"
    t.datetime "old_medical_certificate_updated_at"
    t.string "old_contract_file_name"
    t.string "old_contract_content_type"
    t.bigint "old_contract_file_size"
    t.datetime "old_contract_updated_at"
    t.string "old_iban_file_name"
    t.string "old_iban_content_type"
    t.bigint "old_iban_file_size"
    t.datetime "old_iban_updated_at"
    t.string "old_agent_statement_file_name"
    t.string "old_agent_statement_content_type"
    t.bigint "old_agent_statement_file_size"
    t.datetime "old_agent_statement_updated_at"
    t.string "old_request_transport_costs_file_name"
    t.string "old_request_transport_costs_content_type"
    t.bigint "old_request_transport_costs_file_size"
    t.datetime "old_request_transport_costs_updated_at"
    t.string "old_request_family_supplement_file_name"
    t.string "old_request_family_supplement_content_type"
    t.bigint "old_request_family_supplement_file_size"
    t.datetime "old_request_family_supplement_updated_at"
    t.string "old_statement_sft_file_name"
    t.string "old_statement_sft_content_type"
    t.bigint "old_statement_sft_file_size"
    t.datetime "old_statement_sft_updated_at"
    t.integer "photo_is_validated", limit: 2, default: 0
    t.integer "resume_is_validated", limit: 2, default: 0
    t.integer "cover_letter_is_validated", limit: 2, default: 0
    t.integer "diploma_is_validated", limit: 2, default: 0
    t.integer "identity_is_validated", limit: 2, default: 0
    t.integer "carte_vitale_certificate_is_validated", limit: 2, default: 0
    t.integer "proof_of_address_is_validated", limit: 2, default: 0
    t.integer "medical_certificate_is_validated", limit: 2, default: 0
    t.integer "contract_is_validated", limit: 2, default: 0
    t.integer "iban_is_validated", limit: 2, default: 0
    t.integer "agent_statement_is_validated", limit: 2, default: 0
    t.integer "request_transport_costs_is_validated", limit: 2, default: 0
    t.integer "request_family_supplement_is_validated", limit: 2, default: 0
    t.integer "statement_sft_is_validated", limit: 2, default: 0
    t.string "old_transport_ticket_file_name"
    t.string "old_transport_ticket_content_type"
    t.bigint "old_transport_ticket_file_size"
    t.datetime "old_transport_ticket_updated_at"
    t.integer "transport_ticket_is_validated", limit: 2, default: 0
    t.integer "job_applications_count", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "administrators", "administrators", column: "grand_employer_administrator_id"
  add_foreign_key "administrators", "administrators", column: "inviter_id"
  add_foreign_key "administrators", "administrators", column: "supervisor_administrator_id"
  add_foreign_key "administrators", "employers"
  add_foreign_key "emails", "job_applications"
  add_foreign_key "job_application_files", "job_application_file_types"
  add_foreign_key "job_application_files", "job_applications"
  add_foreign_key "job_applications", "employers"
  add_foreign_key "job_applications", "job_offers"
  add_foreign_key "job_applications", "rejection_reasons"
  add_foreign_key "job_applications", "users"
  add_foreign_key "job_offer_actors", "administrators"
  add_foreign_key "job_offer_actors", "job_offers"
  add_foreign_key "job_offers", "administrators", column: "owner_id"
  add_foreign_key "job_offers", "bops"
  add_foreign_key "job_offers", "categories"
  add_foreign_key "job_offers", "contract_types"
  add_foreign_key "job_offers", "employers"
  add_foreign_key "job_offers", "experience_levels"
  add_foreign_key "job_offers", "professional_categories"
  add_foreign_key "job_offers", "sectors"
  add_foreign_key "job_offers", "study_levels"
  add_foreign_key "messages", "administrators"
  add_foreign_key "messages", "job_applications"
  add_foreign_key "personal_profiles", "experience_levels"
  add_foreign_key "personal_profiles", "study_levels"
  add_foreign_key "preferred_users", "preferred_users_lists"
  add_foreign_key "preferred_users", "users"
  add_foreign_key "preferred_users_lists", "administrators"
  add_foreign_key "salary_ranges", "experience_levels"
  add_foreign_key "salary_ranges", "professional_categories"
  add_foreign_key "salary_ranges", "sectors"
end
