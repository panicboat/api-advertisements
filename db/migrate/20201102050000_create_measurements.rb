class CreateMeasurements < ActiveRecord::Migration[6.0]
  def change
    create_table :measurements, comment: '計測' do |t|
      t.references  :campaign,  null: false,  comment: 'キャンペーンID'
      t.string      :label,     null: true,   comment: 'ラベル'
      t.boolean     :default,   null: false,  comment: 'デフォルト設定'
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3

      t.timestamps
    end
    add_foreign_key :measurements, :campaigns
  end
end
