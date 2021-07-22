# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_22_125727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrators", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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
    t.uuid "organization_id"
    t.date "marked_for_deactivation_on"
    t.index ["confirmation_token"], name: "index_administrators_on_confirmation_token", unique: true
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["employer_id"], name: "index_administrators_on_employer_id"
    t.index ["grand_employer_administrator_id"], name: "index_administrators_on_grand_employer_administrator_id"
    t.index ["inviter_id"], name: "index_administrators_on_inviter_id"
    t.index ["organization_id"], name: "index_administrators_on_organization_id"
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["supervisor_administrator_id"], name: "index_administrators_on_supervisor_administrator_id"
    t.index ["unlock_token"], name: "index_administrators_on_unlock_token", unique: true
  end

  create_table "age_ranges", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_age_ranges_on_name"
    t.index ["position"], name: "index_age_ranges_on_position"
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

  create_table "availability_ranges", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_availability_ranges_on_name"
    t.index ["position"], name: "index_availability_ranges_on_position"
  end

  create_table "benefit_job_offers", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "benefit_id", null: false
    t.uuid "job_offer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["benefit_id"], name: "index_benefit_job_offers_on_benefit_id"
    t.index ["job_offer_id"], name: "index_benefit_job_offers_on_job_offer_id"
  end

  create_table "benefits", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["position"], name: "index_benefits_on_position"
  end

  create_table "bops", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_bops_on_position"
  end

  create_table "categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth", default: 0
    t.integer "children_count", default: 0, null: false
    t.integer "published_job_offers_count", default: 0, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "cmgs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.uuid "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_cmgs_on_organization_id"
  end

  create_table "contract_durations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_contract_durations_on_name", unique: true
    t.index ["position"], name: "index_contract_durations_on_position"
  end

  create_table "contract_types", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "duration", default: false
    t.index ["name"], name: "index_contract_types_on_name", unique: true
    t.index ["position"], name: "index_contract_types_on_position"
  end

  create_table "department_users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "department_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department_id"], name: "index_department_users_on_department_id"
    t.index ["user_id"], name: "index_department_users_on_user_id"
  end

  create_table "departments", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "name_region"
    t.string "code_region"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_attachments", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "email_id", null: false
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_id"], name: "index_email_attachments_on_email_id"
  end

  create_table "email_templates", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["position"], name: "index_email_templates_on_position"
  end

  create_table "emails", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "employers", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "experience_levels", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_experience_levels_on_name", unique: true
    t.index ["position"], name: "index_experience_levels_on_position"
  end

  create_table "foreign_language_levels", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "foreign_languages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "frequently_asked_questions", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "job_application_file_types", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "kind"
    t.string "content_file_name"
    t.boolean "by_default", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_state"
    t.boolean "notification", default: true
    t.boolean "spontaneous", default: false
  end

  create_table "job_application_files", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "content_file_name"
    t.integer "is_validated", limit: 2, default: 0
    t.uuid "job_application_id"
    t.uuid "job_application_file_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "encrypted_file_transfer_in_error", default: false
    t.index ["job_application_file_type_id"], name: "index_job_application_files_on_job_application_file_type_id"
    t.index ["job_application_id"], name: "index_job_application_files_on_job_application_id"
  end

  create_table "job_applications", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.uuid "job_offer_id"
    t.uuid "user_id"
    t.uuid "employer_id"
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
    t.uuid "organization_id"
    t.uuid "category_id"
    t.index ["category_id"], name: "index_job_applications_on_category_id"
    t.index ["employer_id"], name: "index_job_applications_on_employer_id"
    t.index ["job_offer_id"], name: "index_job_applications_on_job_offer_id"
    t.index ["organization_id"], name: "index_job_applications_on_organization_id"
    t.index ["rejection_reason_id"], name: "index_job_applications_on_rejection_reason_id"
    t.index ["state"], name: "index_job_applications_on_state"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "job_offer_actors", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_offer_id"
    t.uuid "administrator_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrator_id"], name: "index_job_offer_actors_on_administrator_id"
    t.index ["job_offer_id"], name: "index_job_offer_actors_on_job_offer_id"
  end

  create_table "job_offer_terms", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_offers", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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
    t.uuid "organization_id"
    t.uuid "benefit_id"
    t.uuid "contract_duration_id"
    t.boolean "featured", default: false
    t.boolean "spontaneous", default: false
    t.text "organization_description"
    t.datetime "draft_at"
    t.index ["benefit_id"], name: "index_job_offers_on_benefit_id"
    t.index ["bop_id"], name: "index_job_offers_on_bop_id"
    t.index ["category_id"], name: "index_job_offers_on_category_id"
    t.index ["contract_duration_id"], name: "index_job_offers_on_contract_duration_id"
    t.index ["contract_type_id"], name: "index_job_offers_on_contract_type_id"
    t.index ["employer_id"], name: "index_job_offers_on_employer_id"
    t.index ["experience_level_id"], name: "index_job_offers_on_experience_level_id"
    t.index ["identifier"], name: "index_job_offers_on_identifier", unique: true
    t.index ["organization_id"], name: "index_job_offers_on_organization_id"
    t.index ["owner_id"], name: "index_job_offers_on_owner_id"
    t.index ["professional_category_id"], name: "index_job_offers_on_professional_category_id"
    t.index ["sector_id"], name: "index_job_offers_on_sector_id"
    t.index ["slug"], name: "index_job_offers_on_slug", unique: true
    t.index ["state"], name: "index_job_offers_on_state"
    t.index ["study_level_id"], name: "index_job_offers_on_study_level_id"
  end

  create_table "messages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "omniauth_informations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.uuid "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid", "provider"], name: "index_omniauth_informations_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_omniauth_informations_on_user_id"
  end

  create_table "organization_defaults", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.text "value"
    t.integer "kind"
    t.uuid "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kind"], name: "index_organization_defaults_on_kind"
    t.index ["organization_id"], name: "index_organization_defaults_on_organization_id"
  end

  create_table "organizations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "service_name"
    t.string "brand_name"
    t.string "administrator_email_suffix"
    t.string "logo_horizontal_file_name"
    t.string "logo_horizontal_content_type"
    t.bigint "logo_horizontal_file_size"
    t.datetime "logo_horizontal_updated_at"
    t.string "image_background_file_name"
    t.string "image_background_content_type"
    t.bigint "image_background_file_size"
    t.datetime "image_background_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "privacy_policy_url"
    t.integer "inbound_email_config", default: 0
    t.string "matomo_site_id"
    t.integer "days_before_publishing"
    t.string "service_description"
    t.string "service_description_short"
    t.string "prefix_article"
    t.string "linkedin_url"
    t.string "twitter_url"
    t.string "youtube_url"
    t.string "instagram_url"
    t.string "facebook_url"
    t.string "operator_name"
    t.string "operator_url"
    t.string "operator_logo_file_name"
    t.string "operator_logo_content_type"
    t.bigint "operator_logo_file_size"
    t.datetime "operator_logo_updated_at"
    t.string "partner_1_name"
    t.string "partner_1_url"
    t.string "partner_1_logo_file_name"
    t.string "partner_1_logo_content_type"
    t.bigint "partner_1_logo_file_size"
    t.datetime "partner_1_logo_updated_at"
    t.string "partner_2_name"
    t.string "partner_2_url"
    t.string "partner_2_logo_file_name"
    t.string "partner_2_logo_content_type"
    t.bigint "partner_2_logo_file_size"
    t.datetime "partner_2_logo_updated_at"
    t.string "partner_3_name"
    t.string "partner_3_url"
    t.string "partner_3_logo_file_name"
    t.string "partner_3_logo_content_type"
    t.bigint "partner_3_logo_file_size"
    t.datetime "partner_3_logo_updated_at"
    t.string "testimony_title"
    t.string "testimony_subtitle"
    t.string "testimony_url"
    t.string "testimony_logo_file_name"
    t.string "testimony_logo_content_type"
    t.bigint "testimony_logo_file_size"
    t.datetime "testimony_logo_updated_at"
    t.string "atinternet_site_id"
    t.string "job_offer_term_title"
    t.string "job_offer_term_subtitle"
    t.string "job_offer_term_warning"
  end

  create_table "pages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.boolean "only_link", default: false, null: false
    t.uuid "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth"
    t.integer "children_count", default: 0, null: false
    t.text "body"
    t.string "url"
    t.string "og_title"
    t.string "og_description"
    t.uuid "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lft"], name: "index_pages_on_lft"
    t.index ["organization_id"], name: "index_pages_on_organization_id"
    t.index ["parent_id"], name: "index_pages_on_parent_id"
    t.index ["rgt"], name: "index_pages_on_rgt"
  end

  create_table "preferred_users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "preferred_users_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["preferred_users_list_id"], name: "index_preferred_users_on_preferred_users_list_id"
    t.index ["user_id"], name: "index_preferred_users_on_user_id"
  end

  create_table "preferred_users_lists", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "administrator_id"
    t.integer "preferred_users_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["administrator_id"], name: "index_preferred_users_lists_on_administrator_id"
  end

  create_table "professional_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_professional_categories_on_name", unique: true
    t.index ["position"], name: "index_professional_categories_on_position"
  end

  create_table "profile_foreign_languages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id", null: false
    t.uuid "foreign_language_id", null: false
    t.uuid "foreign_language_level_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["foreign_language_id"], name: "index_profile_foreign_languages_on_foreign_language_id"
    t.index ["foreign_language_level_id"], name: "index_profile_foreign_languages_on_foreign_language_level_id"
    t.index ["profile_id"], name: "index_profile_foreign_languages_on_profile_id"
  end

  create_table "profiles", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "profileable_type"
    t.uuid "profileable_id"
    t.integer "gender"
    t.boolean "is_currently_employed"
    t.uuid "study_level_id"
    t.uuid "experience_level_id"
    t.boolean "has_corporate_experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "availability_range_id"
    t.uuid "age_range_id"
    t.index ["age_range_id"], name: "index_profiles_on_age_range_id"
    t.index ["availability_range_id"], name: "index_profiles_on_availability_range_id"
    t.index ["experience_level_id"], name: "index_profiles_on_experience_level_id"
    t.index ["profileable_type", "profileable_id"], name: "index_personal_profileable_type_and_id"
    t.index ["study_level_id"], name: "index_profiles_on_study_level_id"
  end

  create_table "rejection_reasons", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["position"], name: "index_rejection_reasons_on_position"
  end

  create_table "salary_ranges", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "sectors", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_sectors_on_name", unique: true
    t.index ["position"], name: "index_sectors_on_position"
  end

  create_table "study_levels", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.integer "official_level"
    t.index ["name"], name: "index_study_levels_on_name", unique: true
    t.index ["position"], name: "index_study_levels_on_position"
  end

  create_table "users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
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
    t.integer "photo_is_validated", limit: 2, default: 0
    t.integer "job_applications_count", default: 0, null: false
    t.uuid "organization_id"
    t.boolean "encrypted_file_transfer_in_error", default: false
    t.string "website_url"
    t.string "phone"
    t.string "current_position"
    t.string "suspension_reason"
    t.datetime "suspended_at"
    t.date "marked_for_deletion_on"
    t.boolean "receive_job_offer_mails", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "administrators", "administrators", column: "grand_employer_administrator_id"
  add_foreign_key "administrators", "administrators", column: "inviter_id"
  add_foreign_key "administrators", "administrators", column: "supervisor_administrator_id"
  add_foreign_key "administrators", "employers"
  add_foreign_key "benefit_job_offers", "benefits"
  add_foreign_key "benefit_job_offers", "job_offers"
  add_foreign_key "cmgs", "organizations"
  add_foreign_key "department_users", "departments"
  add_foreign_key "department_users", "users"
  add_foreign_key "email_attachments", "emails"
  add_foreign_key "emails", "job_applications"
  add_foreign_key "job_application_files", "job_application_file_types"
  add_foreign_key "job_application_files", "job_applications"
  add_foreign_key "job_applications", "categories"
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
  add_foreign_key "organization_defaults", "organizations"
  add_foreign_key "pages", "organizations"
  add_foreign_key "preferred_users", "preferred_users_lists"
  add_foreign_key "preferred_users", "users"
  add_foreign_key "preferred_users_lists", "administrators"
  add_foreign_key "profile_foreign_languages", "foreign_language_levels"
  add_foreign_key "profile_foreign_languages", "foreign_languages"
  add_foreign_key "profile_foreign_languages", "profiles"
  add_foreign_key "profiles", "age_ranges"
  add_foreign_key "profiles", "availability_ranges"
  add_foreign_key "profiles", "experience_levels"
  add_foreign_key "profiles", "study_levels"
  add_foreign_key "salary_ranges", "experience_levels"
  add_foreign_key "salary_ranges", "professional_categories"
  add_foreign_key "salary_ranges", "sectors"
end
