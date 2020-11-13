class CreateAgencies < ActiveRecord::Migration[6.0]
  def change
    create_table :agencies, comment: '代理店' do |t|
      t.string  :name,            null: false,  comment: '名前'
      t.string  :url,             null: false,  comment: 'URL'
      t.string  :representative,  null: true,   comment: '担当者名'
      t.string  :contact,         null: true,   comment: '連絡先'
      t.string  :note,            null: true,   comment: '備考'

      t.timestamps
    end
    add_index :agencies, [:url], unique: true
  end
end
