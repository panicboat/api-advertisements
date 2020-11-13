class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, comment: 'イベント' do |t|
      t.references  :campaign,  null: false,  comment: 'キャンペーンID'
      t.string      :name,      null: false,  comment: '名前'
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3
      t.string      :note,      null: true,   comment: '備考'

      t.timestamps
    end
    add_foreign_key :events, :campaigns
    add_index :events, %i[campaign_id name], unique: true
  end
end
