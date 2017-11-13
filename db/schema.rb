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

ActiveRecord::Schema.define(version: 20171110151255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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

  create_table "applicants", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "full_name"
    t.string   "has_previous_name"
    t.string   "previous_full_name"
    t.string   "gender"
    t.string   "birthplace"
    t.string   "address"
    t.string   "postcode"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "email"
    t.uuid     "c100_application_id"
    t.date     "dob"
    t.index ["c100_application_id"], name: "index_applicants_on_c100_application_id", using: :btree
  end

  create_table "c100_applications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "navigation_stack",                         default: [],              array: true
    t.uuid     "user_id"
    t.string   "user_type"
    t.integer  "number_of_children"
    t.string   "help_paying"
    t.string   "hwf_reference_number"
    t.string   "children_known_to_authorities"
    t.text     "children_known_to_authorities_details"
    t.string   "children_protection_plan"
    t.text     "children_protection_plan_details"
    t.string   "children_same_parents"
    t.text     "children_same_parents_yes_details"
    t.text     "children_same_parents_no_details"
    t.text     "children_parental_responsibility_details"
    t.string   "children_residence"
    t.text     "children_residence_details"
    t.index ["user_id"], name: "index_c100_applications_on_user_id", using: :btree
  end

  create_table "children", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "full_name"
    t.date     "dob"
    t.boolean  "dob_unknown"
    t.string   "gender"
    t.text     "orders_applied_for"
    t.text     "applicants_relationship"
    t.text     "respondents_relationship"
    t.uuid     "c100_application_id"
    t.index ["c100_application_id"], name: "index_children_on_c100_application_id", using: :btree
  end

  create_table "respondents", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "full_name"
    t.string   "has_previous_name"
    t.string   "previous_full_name"
    t.string   "gender"
    t.date     "dob"
    t.boolean  "dob_unknown"
    t.string   "birthplace"
    t.string   "address"
    t.string   "postcode"
    t.boolean  "postcode_unknown"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.boolean  "mobile_phone_unknown"
    t.string   "email"
    t.boolean  "email_unknown"
    t.uuid     "c100_application_id"
    t.index ["c100_application_id"], name: "index_respondents_on_c100_application_id", using: :btree
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

  add_foreign_key "abuse_concerns", "c100_applications"
  add_foreign_key "applicants", "c100_applications"
  add_foreign_key "c100_applications", "users"
  add_foreign_key "children", "c100_applications"
  add_foreign_key "respondents", "c100_applications"
end
