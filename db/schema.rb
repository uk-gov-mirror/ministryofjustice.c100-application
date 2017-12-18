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

ActiveRecord::Schema.define(version: 20171215143416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "abduction_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string  "children_have_passport"
    t.string  "international_risk"
    t.string  "passport_office_notified"
    t.string  "children_multiple_passports"
    t.boolean "passport_possession_mother"
    t.boolean "passport_possession_father"
    t.boolean "passport_possession_other"
    t.text    "passport_possession_other_details"
    t.string  "previous_attempt"
    t.text    "previous_attempt_details"
    t.string  "previous_attempt_agency_involved"
    t.text    "previous_attempt_agency_details"
    t.text    "risk_details"
    t.uuid    "c100_application_id"
    t.index ["c100_application_id"], name: "index_abduction_details_on_c100_application_id", using: :btree
  end

  create_table "abuse_concerns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "subject"
    t.string "kind"
    t.string "answer"
    t.text   "behaviour_description"
    t.string "behaviour_start"
    t.string "behaviour_ongoing"
    t.string "behaviour_stop"
    t.string "asked_for_help"
    t.string "help_party"
    t.string "help_provided"
    t.text   "help_description"
    t.uuid   "c100_application_id"
    t.index ["c100_application_id"], name: "index_abuse_concerns_on_c100_application_id", using: :btree
  end

  create_table "asking_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.boolean "child_home"
    t.boolean "child_times"
    t.boolean "child_contact"
    t.boolean "child_specific_issue"
    t.boolean "child_specific_issue_school"
    t.boolean "child_specific_issue_religion"
    t.boolean "child_specific_issue_name"
    t.boolean "child_specific_issue_medical"
    t.boolean "child_specific_issue_abroad"
    t.boolean "child_return"
    t.boolean "child_abduction"
    t.boolean "child_flight"
    t.boolean "other"
    t.text    "other_details"
    t.boolean "child_arrangements_order"
    t.boolean "prohibited_steps_order"
    t.boolean "specific_issue_order"
    t.uuid    "c100_application_id"
    t.index ["c100_application_id"], name: "index_asking_orders_on_c100_application_id", using: :btree
  end

  create_table "c100_applications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "navigation_stack",                      default: [],              array: true
    t.uuid     "user_id"
    t.string   "user_type"
    t.integer  "number_of_children"
    t.string   "help_paying"
    t.string   "hwf_reference_number"
    t.string   "children_known_to_authorities"
    t.text     "children_known_to_authorities_details"
    t.string   "children_protection_plan"
    t.text     "children_protection_plan_details"
    t.string   "has_court_orders"
    t.string   "concerns_contact_type"
    t.string   "concerns_contact_other"
    t.string   "children_previous_proceedings"
    t.string   "emergency_proceedings"
    t.string   "risk_of_abduction"
    t.string   "substance_abuse"
    t.text     "substance_abuse_details"
    t.string   "children_abuse"
    t.string   "domestic_abuse"
    t.string   "other_abuse"
    t.boolean  "miam_acknowledgement"
    t.string   "miam_attended"
    t.string   "miam_certification"
    t.string   "alternative_negotiation_tools"
    t.string   "alternative_mediation"
    t.string   "alternative_lawyer_negotiation"
    t.string   "alternative_collaborative_law"
    t.date     "miam_certification_date"
    t.string   "miam_certification_number"
    t.string   "has_other_children"
    t.string   "has_other_parties"
    t.string   "address_confidentiality"
    t.boolean  "court_acknowledgement"
    t.index ["user_id"], name: "index_c100_applications_on_user_id", using: :btree
  end

  create_table "child_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid   "child_id"
    t.string "orders",   default: [], array: true
    t.index ["child_id"], name: "index_child_orders_on_child_id", using: :btree
  end

  create_table "court_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "non_molestation"
    t.date   "non_molestation_issue_date"
    t.string "non_molestation_length"
    t.string "non_molestation_is_current"
    t.string "non_molestation_court_name"
    t.string "occupation"
    t.date   "occupation_issue_date"
    t.string "occupation_length"
    t.string "occupation_is_current"
    t.string "occupation_court_name"
    t.string "forced_marriage_protection"
    t.date   "forced_marriage_protection_issue_date"
    t.string "forced_marriage_protection_length"
    t.string "forced_marriage_protection_is_current"
    t.string "forced_marriage_protection_court_name"
    t.string "restraining"
    t.date   "restraining_issue_date"
    t.string "restraining_length"
    t.string "restraining_is_current"
    t.string "restraining_court_name"
    t.string "injunctive"
    t.date   "injunctive_issue_date"
    t.string "injunctive_length"
    t.string "injunctive_is_current"
    t.string "injunctive_court_name"
    t.string "undertaking"
    t.date   "undertaking_issue_date"
    t.string "undertaking_length"
    t.string "undertaking_is_current"
    t.string "undertaking_court_name"
    t.uuid   "c100_application_id"
    t.index ["c100_application_id"], name: "index_court_orders_on_c100_application_id", using: :btree
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "type",                                      null: false
    t.string   "name"
    t.string   "full_name"
    t.string   "has_previous_name"
    t.string   "previous_name"
    t.string   "gender"
    t.date     "dob"
    t.boolean  "dob_unknown",               default: false
    t.string   "age_estimate"
    t.string   "birthplace"
    t.text     "address"
    t.string   "postcode"
    t.boolean  "postcode_unknown",          default: false
    t.string   "home_phone"
    t.boolean  "home_phone_unknown",        default: false
    t.string   "mobile_phone"
    t.boolean  "mobile_phone_unknown",      default: false
    t.string   "email"
    t.boolean  "email_unknown",             default: false
    t.string   "residence_requirement_met"
    t.text     "residence_history"
    t.uuid     "c100_application_id"
    t.index ["c100_application_id"], name: "index_people_on_c100_application_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "abduction_details", "c100_applications"
  add_foreign_key "abuse_concerns", "c100_applications"
  add_foreign_key "asking_orders", "c100_applications"
  add_foreign_key "c100_applications", "users"
  add_foreign_key "child_orders", "people", column: "child_id"
  add_foreign_key "court_orders", "c100_applications"
  add_foreign_key "people", "c100_applications"
end
