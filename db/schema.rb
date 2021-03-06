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

ActiveRecord::Schema.define(version: 2021_03_05_191238) do

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.text "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "post_id"
    t.integer "editor_id"
    t.text "suggestions"
    t.text "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "email"
    t.text "state"
    t.text "password"
    t.text "verify_account_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "verify_account_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_verify_account_tokens_on_token", unique: true
  end

end
