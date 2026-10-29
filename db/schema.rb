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

ActiveRecord::Schema[8.1].define(version: 2026_10_13_105942) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "uuid-ossp"

  create_table "abduction_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.string "children_have_passport"
    t.string "children_multiple_passports"
    t.text "current_location"
    t.string "passport_office_notified"
    t.string "passport_possession", default: [], array: true
    t.text "passport_possession_other_details"
    t.string "previous_attempt"
    t.text "previous_attempt_agency_details"
    t.string "previous_attempt_agency_involved"
    t.text "previous_attempt_details"
    t.text "risk_details"
    t.index ["c100_application_id"], name: "index_abduction_details_on_c100_application_id", unique: true
  end

  create_table "abuse_concerns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "answer"
    t.string "asked_for_help"
    t.text "behaviour_description"
    t.string "behaviour_ongoing"
    t.string "behaviour_start"
    t.string "behaviour_stop"
    t.uuid "c100_application_id"
    t.datetime "created_at", precision: nil
    t.text "help_description"
    t.string "help_party"
    t.string "help_provided"
    t.string "kind"
    t.string "subject"
    t.datetime "updated_at", precision: nil
    t.index ["c100_application_id"], name: "index_abuse_concerns_on_c100_application_id"
  end

  create_table "backoffice_audit_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action", null: false
    t.string "author", null: false
    t.datetime "created_at", precision: nil, null: false
    t.json "details", default: {}
    t.index ["author"], name: "index_backoffice_audit_records_on_author"
  end

  create_table "backoffice_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "current_login_at", precision: nil
    t.string "email", null: false
    t.datetime "last_login_at", precision: nil
    t.integer "logins_count", default: 0
    t.index ["email"], name: "index_backoffice_users_on_email", unique: true
  end

  create_table "c100_applications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "address_confidentiality"
    t.string "alternative_collaborative_law"
    t.string "alternative_lawyer_negotiation"
    t.string "alternative_mediation"
    t.string "alternative_negotiation_tools"
    t.text "application_details"
    t.string "attach_evidence"
    t.string "child_protection_cases"
    t.string "children_abuse"
    t.string "children_known_to_authorities"
    t.text "children_known_to_authorities_details"
    t.string "children_postcode"
    t.string "children_previous_proceedings"
    t.string "children_protection_plan"
    t.text "children_protection_plan_details"
    t.datetime "completed_at", precision: nil
    t.string "concerns_contact_other"
    t.string "concerns_contact_type"
    t.string "consent_order"
    t.boolean "court_acknowledgement"
    t.string "court_id"
    t.string "court_order_case_number"
    t.date "court_order_expiry_date"
    t.datetime "created_at", precision: nil, null: false
    t.string "declaration_confirmation"
    t.string "declaration_signee"
    t.string "declaration_signee_capacity"
    t.string "domestic_abuse"
    t.text "exemption_details"
    t.text "exemption_reasons"
    t.string "existing_court_order"
    t.string "existing_court_order_uploadable"
    t.uuid "files_collection_ref", default: -> { "uuid_generate_v4()" }
    t.string "has_court_orders"
    t.string "has_myhmcts_account"
    t.string "has_other_children"
    t.string "has_other_parties"
    t.string "has_solicitor"
    t.string "hwf_reference_number"
    t.string "international_jurisdiction"
    t.text "international_jurisdiction_details"
    t.string "international_request"
    t.text "international_request_details"
    t.string "international_resident"
    t.text "international_resident_details"
    t.string "is_legal_representative"
    t.string "is_solicitor"
    t.string "mediation_voucher_scheme"
    t.boolean "miam_acknowledgement"
    t.string "miam_attended"
    t.string "miam_certification"
    t.date "miam_certification_date"
    t.string "miam_certification_number"
    t.string "miam_certification_service_name"
    t.string "miam_certification_sole_trader_name"
    t.string "miam_exemption_claim"
    t.string "miam_mediator_exemption"
    t.string "navigation_stack", default: [], array: true
    t.string "orders", default: [], array: true
    t.text "orders_additional_details"
    t.string "other_abuse"
    t.text "participation_capacity_details"
    t.text "participation_other_factors_details"
    t.text "participation_referral_or_assessment_details"
    t.string "payment_type"
    t.text "permission_details"
    t.string "permission_sought"
    t.string "platform"
    t.string "protection_orders"
    t.text "protection_orders_details"
    t.string "receipt_email"
    t.string "reduced_litigation_capacity"
    t.string "reminder_status"
    t.string "research_consent"
    t.string "research_consent_email"
    t.string "risk_of_abduction"
    t.string "solicitor_account_number"
    t.string "start_or_continue"
    t.integer "status", default: 0
    t.string "submission_type"
    t.string "substance_abuse"
    t.text "substance_abuse_details"
    t.datetime "updated_at", precision: nil, null: false
    t.string "urgent_hearing"
    t.text "urgent_hearing_details"
    t.string "urgent_hearing_short_notice"
    t.text "urgent_hearing_short_notice_details"
    t.string "urgent_hearing_when"
    t.string "use_my_hmcts"
    t.uuid "user_id"
    t.string "user_type"
    t.integer "version", default: 5
    t.string "without_notice"
    t.text "without_notice_details"
    t.string "without_notice_frustrate"
    t.text "without_notice_frustrate_details"
    t.string "without_notice_impossible"
    t.text "without_notice_impossible_details"
    t.index ["court_id"], name: "index_c100_applications_on_court_id"
    t.index ["status"], name: "index_c100_applications_on_status"
    t.index ["user_id"], name: "index_c100_applications_on_user_id"
  end

  create_table "child_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "child_id"
    t.string "orders", default: [], array: true
    t.index ["child_id"], name: "index_child_orders_on_child_id", unique: true
  end

  create_table "child_residences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "child_id"
    t.string "person_ids", default: [], array: true
    t.index ["child_id"], name: "index_child_residences_on_child_id", unique: true
  end

  create_table "completed_applications_audit", id: false, force: :cascade do |t|
    t.datetime "completed_at", precision: nil, null: false
    t.string "court", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "reference_code", null: false
    t.datetime "started_at", precision: nil, null: false
    t.string "submission_type"
    t.index ["reference_code"], name: "index_completed_applications_audit_on_reference_code", unique: true
  end

  create_table "court_arrangements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "intermediary_help"
    t.text "intermediary_help_details"
    t.text "language_interpreter_details"
    t.string "language_options", array: true
    t.text "sign_language_interpreter_details"
    t.string "special_arrangements", array: true
    t.text "special_arrangements_details"
    t.string "special_assistance", array: true
    t.text "special_assistance_details"
    t.datetime "updated_at", precision: nil, null: false
    t.text "welsh_language_details"
    t.index ["c100_application_id"], name: "index_court_arrangements_on_c100_application_id", unique: true
  end

  create_table "court_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.string "forced_marriage_protection"
    t.string "forced_marriage_protection_case_number"
    t.string "forced_marriage_protection_court_name"
    t.string "forced_marriage_protection_is_current"
    t.date "forced_marriage_protection_issue_date"
    t.string "forced_marriage_protection_length"
    t.string "injunctive"
    t.string "injunctive_case_number"
    t.string "injunctive_court_name"
    t.string "injunctive_is_current"
    t.date "injunctive_issue_date"
    t.string "injunctive_length"
    t.string "non_molestation"
    t.string "non_molestation_case_number"
    t.string "non_molestation_court_name"
    t.string "non_molestation_is_current"
    t.date "non_molestation_issue_date"
    t.string "non_molestation_length"
    t.string "occupation"
    t.string "occupation_case_number"
    t.string "occupation_court_name"
    t.string "occupation_is_current"
    t.date "occupation_issue_date"
    t.string "occupation_length"
    t.string "restraining"
    t.string "restraining_case_number"
    t.string "restraining_court_name"
    t.string "restraining_is_current"
    t.date "restraining_issue_date"
    t.string "restraining_length"
    t.string "undertaking"
    t.string "undertaking_case_number"
    t.string "undertaking_court_name"
    t.string "undertaking_is_current"
    t.date "undertaking_issue_date"
    t.string "undertaking_length"
    t.index ["c100_application_id"], name: "index_court_orders_on_c100_application_id"
  end

  create_table "court_proceedings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.text "cafcass_details"
    t.string "case_number"
    t.text "children_names"
    t.string "court_name"
    t.text "order_types"
    t.text "previous_details"
    t.string "proceedings_date"
    t.index ["c100_application_id"], name: "index_court_proceedings_on_c100_application_id"
  end

  create_table "courtfinder_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "encrypted_access_token"
    t.datetime "expires_at"
    t.datetime "updated_at", null: false
  end

  create_table "courts", id: :string, force: :cascade do |t|
    t.jsonb "address", default: {}, null: false
    t.integer "cci_code"
    t.datetime "created_at", precision: nil, null: false
    t.string "email", null: false
    t.string "gbs", null: false
    t.string "name", null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "download_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "c100_application_id", null: false
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["c100_application_id"], name: "index_download_tokens_on_c100_application_id"
    t.index ["token"], name: "index_download_tokens_on_token", unique: true
  end

  create_table "email_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.datetime "created_at", precision: nil
    t.string "email_copy_to"
    t.datetime "sent_at", precision: nil
    t.string "to_address"
    t.datetime "updated_at", precision: nil
    t.datetime "user_copy_sent_at", precision: nil
    t.index ["c100_application_id"], name: "index_email_submissions_on_c100_application_id", unique: true
  end

  create_table "email_submissions_audit", id: :uuid, default: nil, force: :cascade do |t|
    t.datetime "completed_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "reference", null: false
    t.datetime "sent_at", precision: nil
    t.string "status", null: false
    t.string "to", null: false
    t.index ["reference"], name: "index_email_submissions_audit_on_reference"
  end

  create_table "miam_exemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "adr", default: [], array: true
    t.uuid "c100_application_id"
    t.string "domestic", default: [], array: true
    t.string "misc", default: [], array: true
    t.string "protection", default: [], array: true
    t.string "urgency", default: [], array: true
    t.index ["c100_application_id"], name: "index_miam_exemptions_on_c100_application_id", unique: true
  end

  create_table "payment_intents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "c100_application_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "nonce"
    t.string "payment_id"
    t.jsonb "state", default: {}, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["c100_application_id"], name: "index_payment_intents_on_c100_application_id", unique: true
  end

  create_table "payment_report_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "csv_generated"
    t.string "mailer_error"
    t.boolean "mailer_personalised"
    t.integer "mailer_retries", default: 0, null: false
    t.boolean "mailer_started"
    t.string "send_mailer_error"
    t.datetime "updated_at", null: false
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.json "address_data", default: {}
    t.boolean "address_unknown", default: false
    t.string "age_estimate"
    t.string "are_contact_details_private"
    t.string "are_identity_details_private"
    t.string "birthplace"
    t.boolean "birthplace_unknown", default: false
    t.uuid "c100_application_id"
    t.string "cohabit_with_other"
    t.string "contact_details_private", default: [], array: true
    t.datetime "created_at", precision: nil, null: false
    t.date "dob"
    t.date "dob_estimate"
    t.boolean "dob_unknown", default: false
    t.string "email"
    t.string "email_keep_private"
    t.string "email_provided"
    t.boolean "email_unknown", default: false
    t.string "first_name"
    t.string "gender"
    t.string "has_previous_name"
    t.string "home_phone"
    t.boolean "home_phone_unknown", default: false
    t.string "last_name"
    t.string "mobile_keep_private"
    t.string "mobile_not_provided_reason"
    t.string "mobile_phone"
    t.boolean "mobile_phone_unknown", default: false
    t.string "mobile_provided"
    t.string "parental_responsibility"
    t.string "phone_keep_private"
    t.string "phone_number"
    t.string "phone_number_not_provided_reason"
    t.string "phone_number_provided"
    t.boolean "phone_number_unknown", default: false
    t.string "previous_name"
    t.string "privacy_known"
    t.string "refuge"
    t.text "residence_history"
    t.string "residence_keep_private"
    t.string "residence_requirement_met"
    t.string "special_guardianship_order"
    t.string "type", null: false
    t.boolean "under_age"
    t.datetime "updated_at", precision: nil, null: false
    t.string "voicemail_consent"
    t.index ["c100_application_id"], name: "index_people_on_c100_application_id"
  end

  create_table "relationships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "amendment"
    t.uuid "c100_application_id"
    t.string "consent"
    t.string "family"
    t.string "living_arrangement"
    t.string "living_order"
    t.string "local_authority"
    t.uuid "minor_id", null: false
    t.string "parental_responsibility"
    t.uuid "person_id", null: false
    t.string "relation"
    t.string "relation_other_value"
    t.string "relative"
    t.string "time_order"
    t.index ["c100_application_id"], name: "index_relationships_on_c100_application_id"
    t.index ["minor_id", "person_id"], name: "index_relationships_on_minor_id_and_person_id", unique: true
  end

  create_table "short_urls", primary_key: "path", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "target_path"
    t.string "target_url"
    t.datetime "updated_at", precision: nil, null: false
    t.string "utm_campaign"
    t.string "utm_medium"
    t.string "utm_source"
    t.integer "visits", default: 0
  end

  create_table "solicitors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.json "address_data", default: {}
    t.uuid "c100_application_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "dx_number"
    t.string "email"
    t.string "email_provided"
    t.string "fax_number"
    t.string "firm_name"
    t.string "full_name"
    t.string "phone_number"
    t.string "reference"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["c100_application_id"], name: "index_solicitors_on_c100_application_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "abduction_details", "c100_applications"
  add_foreign_key "abuse_concerns", "c100_applications"
  add_foreign_key "c100_applications", "courts"
  add_foreign_key "c100_applications", "users"
  add_foreign_key "child_orders", "people", column: "child_id"
  add_foreign_key "child_residences", "people", column: "child_id"
  add_foreign_key "court_arrangements", "c100_applications"
  add_foreign_key "court_orders", "c100_applications"
  add_foreign_key "court_proceedings", "c100_applications"
  add_foreign_key "download_tokens", "c100_applications"
  add_foreign_key "email_submissions", "c100_applications"
  add_foreign_key "miam_exemptions", "c100_applications"
  add_foreign_key "payment_intents", "c100_applications"
  add_foreign_key "people", "c100_applications"
  add_foreign_key "relationships", "c100_applications"
  add_foreign_key "relationships", "people"
  add_foreign_key "relationships", "people", column: "minor_id"
  add_foreign_key "solicitors", "c100_applications"
end
