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

ActiveRecord::Schema.define(version: 2020_04_23_001306) do

  create_table "archives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "cage"
    t.integer "mouse"
    t.string "changed_attr"
    t.string "acttype"
    t.string "priorval"
    t.string "newval"
    t.integer "who"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "cage_number"
    t.string "cage_type"
    t.string "location"
    t.boolean "cage_number_changed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sex"
    t.string "strain"
    t.date "expected_weaning_date"
    t.boolean "in_use", default: true
    t.string "genotype", default: "0"
    t.string "genotype2", default: "0"
    t.string "strain2"
    t.datetime "last_viewed"
  end

  create_table "datapoints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "mouse_id"
    t.string "var_value"
    t.string "timepoint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "var_name"
    t.string "variable_name"
    t.index ["mouse_id"], name: "index_datapoints_on_mouse_id"
  end

  create_table "experiments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gene"
    t.text "variables"
    t.datetime "last_viewed"
    t.text "protocol"
    t.integer "rows"
    t.text "variable_1"
    t.integer "variable_1_rows"
    t.text "variable_2"
    t.integer "variable_2_rows"
    t.text "variable_3"
    t.integer "variable_3_rows"
  end

  create_table "mice", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "cage_id"
    t.string "sex"
    t.string "genotype"
    t.date "dob"
    t.date "weaning_date"
    t.date "biopsy_collection_date"
    t.string "ear_punch"
    t.string "designation"
    t.date "removed"
    t.integer "parent_cage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "strain"
    t.string "three_digit_code"
    t.text "removed_for"
    t.string "genotype2"
    t.string "strain2"
    t.datetime "tdc_generated"
    t.boolean "pup"
    t.bigint "experiment_id"
    t.string "experiment_code"
    t.index ["cage_id"], name: "index_mice_on_cage_id"
    t.index ["experiment_id"], name: "index_mice_on_experiment_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "first"
    t.string "last"
    t.boolean "editor", default: false
    t.boolean "approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "version_associations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "datapoints", "mice"
  add_foreign_key "mice", "cages"
  add_foreign_key "mice", "experiments"
end
