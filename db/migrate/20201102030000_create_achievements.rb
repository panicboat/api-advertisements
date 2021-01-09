class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements, comment: '単価' do |t|
      t.references  :event,     null: false,  comment: 'イベントID'
      t.string      :label,     null: true,   comment: 'ラベル'
      t.integer     :status,    null: false,  comment: 'ステータス', limit: 3

      t.timestamps
    end
    add_foreign_key :achievements, :events
  end
end
