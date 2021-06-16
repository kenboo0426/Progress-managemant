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

ActiveRecord::Schema.define(version: 2021_06_12_053601) do

  create_table "issues", force: :cascade do |t|
    t.integer "project_id"
    t.integer "issue_id"
    t.string "issue_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "updated"
    t.float "estimate_hours"
    t.date "start_date"
    t.date "closed_on"
  end

  create_table "last_acquisitions", force: :cascade do |t|
    t.integer "project_id"
    t.datetime "last_acquisition"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "outsourcing_costs", force: :cascade do |t|
    t.integer "project_id"
    t.float "cost", null: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "parent_id"
    t.string "project_name"
    t.string "description"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "identifier"
    t.date "created"
    t.date "updated"
    t.string "leader_name"
    t.string "grade"
    t.float "planned_cost"
    t.float "sales"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "roles"
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer "issue_id"
    t.float "hours"
    t.date "spent_on"
    t.string "activity_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "time_entry_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.float "salary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "hide", default: 0
  end

  create_table "versions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "project_id"
    t.integer "version_id"
    t.boolean "qc_checked", default: false
  end

end
