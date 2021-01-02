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

ActiveRecord::Schema.define(version: 2020_11_07_000000) do

  create_table "achievement_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "単価詳細", force: :cascade do |t|
    t.bigint "achievement_id", null: false, comment: "単価ID"
    t.datetime "start_at", comment: "開始日時"
    t.datetime "end_at", comment: "終了日時"
    t.integer "charge", null: false, comment: "請求金額"
    t.integer "payment", null: false, comment: "支払金額"
    t.integer "commission", null: false, comment: "手数料"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["achievement_id", "start_at"], name: "index_achievement_details_on_achievement_id_and_start_at", unique: true
    t.index ["achievement_id"], name: "index_achievement_details_on_achievement_id"
  end

  create_table "achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "単価", force: :cascade do |t|
    t.string "label", comment: "ラベル"
    t.integer "classification", limit: 3, null: false, comment: "単価種別"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "advertisers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "広告主", force: :cascade do |t|
    t.bigint "agency_id", comment: "代理店ID"
    t.string "name", null: false, comment: "名前"
    t.string "url", null: false, comment: "URL"
    t.string "representative", comment: "担当者名"
    t.string "contact", comment: "連絡先"
    t.string "note", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agency_id"], name: "index_advertisers_on_agency_id"
    t.index ["url"], name: "index_advertisers_on_url", unique: true
  end

  create_table "agencies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "代理店", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.string "url", null: false, comment: "URL"
    t.string "representative", comment: "担当者名"
    t.string "contact", comment: "連絡先"
    t.string "note", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url"], name: "index_agencies_on_url", unique: true
  end

  create_table "banner_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "バナー詳細", force: :cascade do |t|
    t.bigint "banner_id", null: false, comment: "バナーID"
    t.datetime "start_at", comment: "開始日時"
    t.datetime "end_at", comment: "終了日時"
    t.string "url", null: false, comment: "バナーURL"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["banner_id", "start_at"], name: "index_banner_details_on_banner_id_and_start_at", unique: true
    t.index ["banner_id"], name: "index_banner_details_on_banner_id"
  end

  create_table "banners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "バナー", force: :cascade do |t|
    t.bigint "product_id", null: false, comment: "プロダクトID"
    t.integer "classification", limit: 3, null: false, comment: "バナー種別"
    t.string "label", comment: "ラベル"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_banners_on_product_id"
  end

  create_table "budget_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "予算詳細", force: :cascade do |t|
    t.bigint "budget_id", null: false, comment: "予算ID"
    t.bigint "campaign_id", null: false, comment: "キャンペーンID"
    t.integer "amount", null: false, comment: "金額"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["budget_id"], name: "index_budget_details_on_budget_id"
    t.index ["campaign_id"], name: "index_budget_details_on_campaign_id"
  end

  create_table "budgets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "予算", force: :cascade do |t|
    t.bigint "product_id", null: false, comment: "プロダクトID"
    t.string "label", comment: "ラベル"
    t.datetime "start_at", null: false, comment: "開始日時"
    t.datetime "end_at", null: false, comment: "終了日時"
    t.integer "amount", null: false, comment: "金額"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_budgets_on_product_id"
  end

  create_table "campaigns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "キャンペーン", force: :cascade do |t|
    t.bigint "product_id", null: false, comment: "プロダクトID"
    t.integer "platform", limit: 3, null: false, comment: "プラットフォーム"
    t.string "store_url", null: false, comment: "ストアURL"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.string "note", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "store_url"], name: "index_campaigns_on_product_id_and_store_url", unique: true
    t.index ["product_id"], name: "index_campaigns_on_product_id"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "イベント", force: :cascade do |t|
    t.bigint "campaign_id", null: false, comment: "キャンペーンID"
    t.string "name", null: false, comment: "名前"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.string "note", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id", "name"], name: "index_events_on_campaign_id_and_name", unique: true
    t.index ["campaign_id"], name: "index_events_on_campaign_id"
  end

  create_table "map_event_achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "イベント成果報酬", force: :cascade do |t|
    t.bigint "event_id", null: false, comment: "イベントID"
    t.bigint "achievement_id", null: false, comment: "成果報酬ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["achievement_id"], name: "index_map_event_achievements_on_achievement_id"
    t.index ["event_id", "achievement_id"], name: "index_map_event_achievements_on_event_id_and_achievement_id", unique: true
    t.index ["event_id"], name: "index_map_event_achievements_on_event_id"
  end

  create_table "measurement_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "計測詳細", force: :cascade do |t|
    t.bigint "measurement_id", null: false, comment: "計測詳細ID"
    t.datetime "start_at", comment: "開始日時"
    t.datetime "end_at", comment: "終了日時"
    t.string "url", null: false, comment: "計測URL"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["measurement_id", "start_at"], name: "index_measurement_details_on_measurement_id_and_start_at", unique: true
    t.index ["measurement_id"], name: "index_measurement_details_on_measurement_id"
  end

  create_table "measurements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "計測", force: :cascade do |t|
    t.bigint "campaign_id", null: false, comment: "キャンペーンID"
    t.string "label", comment: "ラベル"
    t.integer "classification", limit: 3, null: false, comment: "計測種別"
    t.integer "status", limit: 3, null: false, comment: "ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_measurements_on_campaign_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "プロダクト", force: :cascade do |t|
    t.bigint "advertiser_id", null: false, comment: "広告主ID"
    t.string "name", null: false, comment: "名前"
    t.string "url", null: false, comment: "URL"
    t.string "note", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["advertiser_id"], name: "index_products_on_advertiser_id"
    t.index ["url"], name: "index_products_on_url", unique: true
  end

  add_foreign_key "achievement_details", "achievements"
  add_foreign_key "advertisers", "agencies"
  add_foreign_key "banner_details", "banners"
  add_foreign_key "banners", "products"
  add_foreign_key "budget_details", "budgets"
  add_foreign_key "budget_details", "campaigns"
  add_foreign_key "campaigns", "products"
  add_foreign_key "events", "campaigns"
  add_foreign_key "map_event_achievements", "achievements"
  add_foreign_key "map_event_achievements", "events"
  add_foreign_key "measurement_details", "measurements"
  add_foreign_key "measurements", "campaigns"
  add_foreign_key "products", "advertisers"
end
