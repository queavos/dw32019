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

ActiveRecord::Schema.define(version: 2019_10_31_231938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "laboratorios", force: :cascade do |t|
    t.string "lab_desc"
    t.boolean "lab_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productos", force: :cascade do |t|
    t.bigint "rubro_id"
    t.bigint "laboratorio_id"
    t.string "prod_desc"
    t.float "prod_precio"
    t.boolean "prod_activo"
    t.string "prod_bcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["laboratorio_id"], name: "index_productos_on_laboratorio_id"
    t.index ["rubro_id"], name: "index_productos_on_rubro_id"
  end

  create_table "rubros", force: :cascade do |t|
    t.string "rubro_desc"
    t.integer "rubro_iva"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubro_desc"], name: "rubro_idx", unique: true
  end

  add_foreign_key "productos", "laboratorios"
  add_foreign_key "productos", "rubros"
end
