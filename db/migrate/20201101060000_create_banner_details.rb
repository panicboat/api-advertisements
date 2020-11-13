class CreateBannerDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :banner_details, comment: 'バナー詳細' do |t|
      t.references  :banner,    null: false,  comment: 'バナーID'
      t.datetime    :start_at,  null: true,   comment: '開始日時'
      t.datetime    :end_at,    null: true,   comment: '終了日時'
      t.string      :url,       null: false,  comment: 'バナーURL'

      t.timestamps
    end
    add_foreign_key :banner_details, :banners
    add_index :banner_details, %i[banner_id start_at], unique: true
  end
end
