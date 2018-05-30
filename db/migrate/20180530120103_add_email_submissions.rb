class AddEmailSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table "email_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string "to_address"
      t.string "email_copy_to"
      t.datetime "sent_at"
      t.string "message_id"
      t.uuid "c100_application_id"
      t.datetime "user_copy_sent_at"
      t.datetime "user_copy_message_id"
      t.boolean "email_me_a_copy", default: false
      t.index ["c100_application_id"], name: "index_email_submissions_on_c100_application_id"
      t.index ["message_id"], name: "index_email_submissions_on_message_id"
      t.index ["sent_at"], name: "index_email_submissions_on_sent_at"
      t.index ["to_address"], name: "index_email_submissions_on_to_address"
      t.index ["user_copy_message_id"], name: "index_email_submissions_on_user_copy_message_id"
      t.index ["user_copy_sent_at"], name: "index_email_submissions_on_user_copy_sent_at"
    end
  end
end
