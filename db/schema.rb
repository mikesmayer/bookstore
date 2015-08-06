# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150805154341) do

  create_table "addresses", force: :cascade do |t|
    t.string   "user_address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone"
    t.integer  "country_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "price"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "author_id"
    t.integer  "category_id"
    t.string   "cover"
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id"
  add_index "books", ["category_id"], name: "index_books_on_category_id"

  create_table "books_users", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "user_id"
  end

  add_index "books_users", ["book_id"], name: "index_books_users_on_book_id"
  add_index "books_users", ["user_id"], name: "index_books_users_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "category_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "number"
    t.boolean  "used",       default: false
    t.integer  "order_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "sale"
  end

  add_index "coupons", ["order_id"], name: "index_coupons_on_order_id"

  create_table "credit_cards", force: :cascade do |t|
    t.string   "number"
    t.string   "cvv"
    t.integer  "expiration_month"
    t.integer  "expiration_year"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "profile_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "credit_cards", ["profile_id"], name: "index_credit_cards_on_profile_id"

  create_table "order_books", force: :cascade do |t|
    t.decimal  "price"
    t.integer  "quantity"
    t.integer  "book_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "order_books", ["book_id"], name: "index_order_books_on_book_id"
  add_index "order_books", ["order_id"], name: "index_order_books_on_order_id"

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price"
    t.datetime "completed_date"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "status"
    t.integer  "credit_card_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.string   "session_id"
  end

  add_index "orders", ["billing_address_id"], name: "index_orders_on_billing_address_id"
  add_index "orders", ["credit_card_id"], name: "index_orders_on_credit_card_id"
  add_index "orders", ["shipping_address_id"], name: "index_orders_on_shipping_address_id"

  create_table "profiles", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "credit_card_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
  end

  add_index "profiles", ["credit_card_id"], name: "index_profiles_on_credit_card_id"

  create_table "ratings", force: :cascade do |t|
    t.text     "review"
    t.integer  "rating"
    t.integer  "book_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "ratings", ["book_id"], name: "index_ratings_on_book_id"
  add_index "ratings", ["customer_id"], name: "index_ratings_on_customer_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "approved",   default: false
  end

  add_index "reviews", ["book_id"], name: "index_reviews_on_book_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
