class CreateMeasurementDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_details, comment: '計測詳細' do |t|
      t.references  :measurement, null: false,  comment: '計測詳細ID'
      t.datetime    :start_at,    null: true,   comment: '開始日時'
      t.datetime    :end_at,      null: true,   comment: '終了日時'
      t.string      :url,         null: false,  comment: '計測URL'

      t.timestamps
    end
    add_foreign_key :measurement_details, :measurements
    add_index :measurement_details, %i[measurement_id start_at], unique: true
  end
end
