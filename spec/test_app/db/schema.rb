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

ActiveRecord::Schema.define(version: 20171216190917) do

  create_table "auth_m_managements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_m_people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "dni"
    t.bigint "management_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["management_id"], name: "index_auth_m_people_on_management_id"
    t.index ["management_id"], name: "index_managements_on_people"
  end

  create_table "auth_m_policies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "resource_id"
    t.bigint "user_id"
    t.string "access"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_auth_m_policies_on_resource_id"
    t.index ["resource_id"], name: "index_resources_on_policies"
    t.index ["user_id"], name: "index_auth_m_policies_on_user_id"
    t.index ["user_id"], name: "index_users_on_policies"
  end

  create_table "auth_m_resources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.bigint "management_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["management_id"], name: "index_auth_m_resources_on_management_id"
    t.index ["management_id"], name: "index_managements_on_resources"
  end

  create_table "auth_m_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "roles_mask", default: 2, null: false
    t.boolean "active", default: false, null: false
    t.bigint "person_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_auth_m_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_auth_m_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_auth_m_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_auth_m_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_auth_m_users_on_invited_by_type_and_invited_by_id"
    t.index ["person_id"], name: "index_auth_m_users_on_person_id"
    t.index ["person_id"], name: "index_peoples_on_users"
    t.index ["reset_password_token"], name: "index_auth_m_users_on_reset_password_token", unique: true
  end

end
