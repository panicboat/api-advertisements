class CreateMapEventAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :map_event_achievements, comment: 'イベント成果報酬' do |t|
      t.references  :event,         null: false,  comment: 'イベントID'
      t.references  :achievement,   null: false,  comment: '成果報酬ID'

      t.timestamps
    end
    add_foreign_key :map_event_achievements, :events
    add_foreign_key :map_event_achievements, :achievements
    add_index       :map_event_achievements, %i[event_id achievement_id], unique: true
  end
end
