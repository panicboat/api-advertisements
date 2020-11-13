class CreateAchievementDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :achievement_details, comment: '単価詳細' do |t|
      t.references  :achievement, null: false,  comment: '単価ID'
      t.datetime    :start_at,    null: true,   comment: '開始日時'
      t.datetime    :end_at,      null: true,   comment: '終了日時'
      t.integer     :charge,      null: false,  comment: '請求金額'
      t.integer     :payment,     null: false,  comment: '支払金額'
      t.integer     :commission,  null: false,  comment: '手数料'

      t.timestamps
    end
    add_foreign_key :achievement_details, :achievements
    add_index :achievement_details, %i[achievement_id start_at], unique: true
  end
end
