class CreateAdvertisers < ActiveRecord::Migration[6.0]
  def change
    create_table :advertisers, comment: '広告主' do |t|
      t.references  :agency,          null: true,   comment: '代理店ID'
      t.string      :name,            null: false,  comment: '名前'
      t.string      :url,             null: false,  comment: 'URL'
      t.string      :representative,  null: true,   comment: '担当者名'
      t.string      :contact,         null: true,   comment: '連絡先'
      t.string      :note,            null: true,   comment: '備考'

      t.timestamps
    end
    add_foreign_key :advertisers, :agencies
    add_index :advertisers, [:url], unique: true
  end
end
