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

ActiveRecord::Schema.define(version: 2019_11_29_000017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ciudades", force: :cascade do |t|
    t.string "nombre"
    t.bigint "paise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paise_id"], name: "index_ciudades_on_paise_id"
  end

  create_table "paises", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personas", force: :cascade do |t|
    t.string "apellido"
    t.string "nombre"
    t.date "fenac"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genero"
    t.boolean "recibemail"
    t.bigint "paise_id"
    t.index ["paise_id"], name: "index_personas_on_paise_id"
  end

  add_foreign_key "ciudades", "paises"
  add_foreign_key "personas", "paises"
end
