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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130823125918) do

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rulez_alternatives", :force => true do |t|
    t.string   "description"
    t.text     "condition"
    t.text     "alternative"
    t.integer  "rule_id"
    t.integer  "priority"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rulez_contexts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rulez_contexts_variables", :force => true do |t|
    t.integer "context_id"
    t.integer "variable_id"
  end

  create_table "rulez_rules", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "rule"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "context_id"
  end

  create_table "rulez_variables", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "model"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
