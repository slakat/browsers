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

ActiveRecord::Schema.define(version: 20160329014102) do

  create_table "all_matches", force: :cascade do |t|
    t.integer  "match_counts", limit: 4
    t.integer  "segment",      limit: 4
    t.integer  "relation_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "all_matches", ["relation_id"], name: "index_all_matches_on_relation_id", using: :btree
  add_index "all_matches", ["segment"], name: "index_all_matches_on_segment", using: :btree

  create_table "comparisons", force: :cascade do |t|
    t.integer  "result_a_id",   limit: 4
    t.integer  "result_b_id",   limit: 4
    t.boolean  "same_content",  limit: 1
    t.boolean  "related_pages", limit: 1
    t.integer  "relation_id",   limit: 4
    t.string   "error",         limit: 191
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "comparisons", ["error"], name: "index_comparisons_on_error", using: :btree
  add_index "comparisons", ["relation_id"], name: "index_comparisons_on_relation_id", using: :btree
  add_index "comparisons", ["result_a_id"], name: "index_comparisons_on_result_a_id", using: :btree
  add_index "comparisons", ["result_b_id"], name: "index_comparisons_on_result_b_id", using: :btree

  create_table "dirty_matches", force: :cascade do |t|
    t.integer  "match_counts", limit: 4
    t.integer  "segment",      limit: 4
    t.integer  "relation_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "dirty_matches", ["relation_id"], name: "index_dirty_matches_on_relation_id", using: :btree
  add_index "dirty_matches", ["segment"], name: "index_dirty_matches_on_segment", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "result_a_id",   limit: 4
    t.integer  "result_b_id",   limit: 4
    t.boolean  "same_content",  limit: 1
    t.boolean  "related_pages", limit: 1
    t.integer  "relation_id",   limit: 4
    t.string   "error",         limit: 191
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "likes", ["error"], name: "index_likes_on_error", using: :btree
  add_index "likes", ["relation_id"], name: "index_likes_on_relation_id", using: :btree
  add_index "likes", ["result_a_id"], name: "index_likes_on_result_a_id", using: :btree
  add_index "likes", ["result_b_id"], name: "index_likes_on_result_b_id", using: :btree

  create_table "perfect_matches", force: :cascade do |t|
    t.integer  "match_counts", limit: 4
    t.integer  "segment",      limit: 4
    t.integer  "relation_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "perfect_matches", ["relation_id"], name: "index_perfect_matches_on_relation_id", using: :btree
  add_index "perfect_matches", ["segment"], name: "index_perfect_matches_on_segment", using: :btree

  create_table "records", force: :cascade do |t|
    t.string   "search",     limit: 191
    t.string   "country",    limit: 191
    t.string   "browser",    limit: 191
    t.datetime "dateprint"
    t.string   "rol",        limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "records", ["browser"], name: "index_records_on_browser", using: :btree
  add_index "records", ["country"], name: "index_records_on_country", using: :btree
  add_index "records", ["dateprint"], name: "index_records_on_dateprint", using: :btree
  add_index "records", ["search"], name: "index_records_on_search", using: :btree

  create_table "relations", force: :cascade do |t|
    t.integer  "record_a_id", limit: 4
    t.integer  "record_b_id", limit: 4
    t.string   "search",      limit: 191
    t.datetime "time_a"
    t.datetime "time_b"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "relations", ["record_a_id"], name: "index_relations_on_record_a_id", using: :btree
  add_index "relations", ["record_b_id"], name: "index_relations_on_record_b_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "position",   limit: 4
    t.string   "title",      limit: 191
    t.string   "link",       limit: 191
    t.text     "snippet",    limit: 65535
    t.integer  "record_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "results", ["record_id"], name: "index_results_on_record_id", using: :btree

  create_table "similarities", force: :cascade do |t|
    t.integer  "result_a_id",   limit: 4
    t.integer  "result_b_id",   limit: 4
    t.boolean  "same_content",  limit: 1
    t.boolean  "related_pages", limit: 1
    t.integer  "relation_id",   limit: 4
    t.string   "error",         limit: 191
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "similarities", ["error"], name: "index_similarities_on_error", using: :btree
  add_index "similarities", ["relation_id"], name: "index_similarities_on_relation_id", using: :btree
  add_index "similarities", ["result_a_id"], name: "index_similarities_on_result_a_id", using: :btree
  add_index "similarities", ["result_b_id"], name: "index_similarities_on_result_b_id", using: :btree

  add_foreign_key "all_matches", "relations"
  add_foreign_key "dirty_matches", "relations"
  add_foreign_key "perfect_matches", "relations"
  add_foreign_key "results", "records"
end
