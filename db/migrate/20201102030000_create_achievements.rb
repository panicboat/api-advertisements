class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements, comment: '単価' do |t|
      t.string      :label,     null: true,   comment: 'ラベル'
      t.integer     :classification,      null: false,  comment: '単価種別', limit: 3
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3

      t.timestamps
    end
  end
end
