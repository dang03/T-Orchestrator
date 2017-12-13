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

ActiveRecord::Schema.define(version: 20150531502301) do

  create_table "assurance_parameters", force: :cascade do |t|
    t.string   "limit"
    t.string   "value"
    t.string   "unit"
    t.string   "violation"
    t.string   "penalty"
    t.integer  "sla_specification_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "connection_points", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "ns_id"
  end

  create_table "constituent_vnfs", force: :cascade do |t|
    t.string  "vnf_reference"
    t.string  "vnf_flavour_id_reference"
    t.string  "redundancy_model"
    t.string  "affinity"
    t.string  "capability"
    t.string  "number_of_instances"
    t.integer "service_deployment_flavour_id"
  end

  create_table "lifecycle_events", force: :cascade do |t|
    t.string  "sla_id"
    t.integer "ns_id"
  end

  create_table "monitoring_parameters", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "definition"
    t.integer "ns_id"
  end

  create_table "ns", force: :cascade do |t|
    t.string   "ns_id"
    t.string   "vendor"
    t.string   "version"
    t.boolean  "published_to_customers", default: false
    t.boolean  "availability",           default: false
    t.string   "vnfs"
    t.string   "vnffgd"
    t.string   "vld"
    t.string   "vnf_dependencies"
    t.string   "lifecycle_events"
    t.string   "auto_scale_policy"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "service_deployment_flavours", force: :cascade do |t|
    t.string   "flavour_key"
    t.integer  "ns_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sla_specifications", force: :cascade do |t|
    t.string   "sla_id"
    t.integer  "ns_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
